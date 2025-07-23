{
  lib,
  stdenv,
  nodejs,
  jq,
  diffutils,
  prefetch-npm-deps,
  srcOnly,
  makeSetupHook,
  pkg-config,
  node-gyp,
  xcbuild,
  writeText,
  libsecret,
  buildPackages,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:
let
  hash =
    if stdenv.hostPlatform.isDarwin then
      "sha256-w1a7CP4lHVYxNKCZyRZd4X8jsi/DOlmmOa6Jp23Pj+Q="
    else
      "sha256-/6JZYsIYDJHS/8TOPjtR/SrRbzTbL43X0g/tPIn2YfQ=";
  lockHook =
    if stdenv.hostPlatform.isDarwin then
      ''
        ${lib.getExe buildPackages.jq} '
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].version |= "4.22.5" |
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].resolved = "https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.22.5.tgz" |
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].integrity = "sha512-250ZGg4ipTL0TGvLlfACkIxS9+KLtIbn7BCZjsZj88zSg2Lvu3Xdw6dhAhfe/FjjXPVNCtcSp+WZjVsD3a/Zlw==" |
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].cpu = [ "arm64" ] |
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].dev = true |
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].license = [ "MIT" ] |
          .packages["node_modules/rollup/node_modules/@rollup/rollup-darwin-arm64"].os = ["darwin"]
        ' ''${src}/package-lock.json > package-lock.json
      ''
    else
      "";
  customeNpmConfigHook =
    makeSetupHook
      {
        name = "npm-config-hook";
        substitutions = {
          nodeSrc = srcOnly nodejs;
          nodeGyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";

          # Specify `diff`, `jq`, and `prefetch-npm-deps` by abspath to ensure that the user's build
          # inputs do not cause us to find the wrong binaries.
          diff = "${diffutils}/bin/diff";
          jq = "${jq}/bin/jq";
          prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";

          nodeVersion = nodejs.version;
          nodeVersionMajor = lib.versions.major nodejs.version;
        };
      }
      (
        writeText "npm-config-hook.sh" ''
          npmConfigHook() {
              echo "Executing npmConfigHook"

              # Use npm patches in the nodejs package
              export NIX_NODEJS_BUILDNPMPACKAGE=1
              export prefetchNpmDeps="@prefetchNpmDeps@"

              if [ -n "''${npmRoot-}" ]; then
                pushd "$npmRoot"
              fi

              echo "Configuring npm"

              export HOME="$TMPDIR"
              export npm_config_nodedir="@nodeSrc@"
              export npm_config_node_gyp="@nodeGyp@"

              if [ -z "''${npmDeps-}" ]; then
                  echo
                  echo "ERROR: no dependencies were specified"
                  echo 'Hint: set `npmDeps` if using these hooks individually. If this is happening with `buildNpmPackage`, please open an issue.'
                  echo

                  exit 1
              fi

              local -r cacheLockfile="$npmDeps/package-lock.json"
              local -r srcLockfile="$PWD/package-lock.json"

              echo "Validating consistency between $srcLockfile and $cacheLockfile"

              if ! @diff@ "$srcLockfile" "$cacheLockfile"; then
                # If the diff failed, first double-check that the file exists, so we can
                # give a friendlier error msg.
                if ! [ -e "$srcLockfile" ]; then
                  echo
                  echo "ERROR: Missing package-lock.json from src. Expected to find it at: $srcLockfile"
                  echo "Hint: You can copy a vendored package-lock.json file via postPatch."
                  echo

                  exit 1
                fi

                if ! [ -e "$cacheLockfile" ]; then
                  echo
                  echo "ERROR: Missing lockfile from cache. Expected to find it at: $cacheLockfile"
                  echo

                  exit 1
                fi

                echo
                echo "ERROR: npmDepsHash is out of date"
                echo
                echo "The package-lock.json in src is not the same as the in $npmDeps."
                echo
                echo "To fix the issue:"
                echo '1. Use `lib.fakeHash` as the npmDepsHash value'
                echo "2. Build the derivation and wait for it to fail with a hash mismatch"
                echo "3. Copy the 'got: sha256-' value back into the npmDepsHash field"
                echo

                exit 1
              fi

              export CACHE_MAP_PATH="$TMP/MEOW"
              @prefetchNpmDeps@ --map-cache

              @prefetchNpmDeps@ --fixup-lockfile "$srcLockfile"

              local cachePath

              if [ -z "''${makeCacheWritable-}" ]; then
                  cachePath="$npmDeps"
              else
                  echo "Making cache writable"
                  cp -r "$npmDeps" "$TMPDIR/cache"
                  chmod -R 700 "$TMPDIR/cache"
                  cachePath="$TMPDIR/cache"
              fi

              echo "Setting npm_config_cache to $cachePath"
              # do not use npm config to avoid modifying .npmrc
              export npm_config_cache="$cachePath"
              export npm_config_offline="true"
              export npm_config_progress="false"

              echo "Installing dependencies"

              if ! npm ci --ignore-scripts $npmInstallFlags "''${npmInstallFlagsArray[@]}" $npmFlags "''${npmFlagsArray[@]}"; then
                  echo
                  echo "ERROR: npm failed to install dependencies"
                  echo
                  echo "Here are a few things you can try, depending on the error:"
                  echo '1. Set `makeCacheWritable = true`'
                  echo "  Note that this won't help if npm is complaining about not being able to write to the logs directory -- look above that for the actual error."
                  echo '2. Set `npmFlags = [ "--legacy-peer-deps" ]`'
                  echo

                  exit 1
              fi

              sed -i 's/"install": "node install.js",//' node_modules/tree-sitter-cli/package.json
              patchShebangs node_modules

              npm rebuild $npmRebuildFlags "''${npmRebuildFlagsArray[@]}" $npmFlags "''${npmFlagsArray[@]}"

              patchShebangs node_modules

              rm "$CACHE_MAP_PATH"
              unset CACHE_MAP_PATH

              if [ -n "''${npmRoot-}" ]; then
                popd
              fi

              echo "Finished npmConfigHook"
          }

          postPatchHooks+=(npmConfigHook)
        ''
      );
in
buildNpmPackage rec {
  pname = "kulala-ls";
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-ls";
    rev = "v${version}";
    hash = "sha256-We7d6if++n8Y0eouY3I9hbb5iJ+YyaPyFSvu6Ff5U0U=";
  };
  npmConfigHook = customeNpmConfigHook;
  npmDepsHash = hash;
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ];
  nativeBuildInputs = [
    pkg-config
    node-gyp
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];
  npmBuildScript = "build:server";
  npmInstallFlags = [ "--include=dev" ];
  postPatch = ''
    ${lib.getExe buildPackages.jq} '
      .scripts.postinstall |= empty |
      .name |= "kulala-ls" |
      .bin |= "./pkg/server/cli.cjs"
    ' ${src}/package.json > package.json
    ${lockHook}
  '';

  preBuild = ''
    export PATH="node_modules/.bin:$PATH"
  '';
  passthru.updateScript = nix-update-script { };
  makeCacheWritable = true;
  meta = with lib; {
    description = "A minimal 🤏 language 🔊 server 📡 for HTTP 🐼 syntax 🌈.";
    homepage = "https://github.com/mistweaverco/kulala-ls";
    mainProgram = "kulala-ls";
    license = licenses.mit;
    maintainers = with maintainers; [ zeorin ];
  };
}
