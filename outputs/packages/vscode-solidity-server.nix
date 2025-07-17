{
  lib,
  stdenv,
  pkg-config,
  libsecret,
  buildPackages,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "vscode-solidity-server";
  version = "0.0.185";
  src = fetchFromGitHub {
    owner = "juanfranblanco";
    repo = "vscode-solidity";
    rev = "5198201a23874e79248e6b09558ca30e5bf5cdcf";
    hash = "sha256-GHa2VbMyYn0FXEhd1my0851rbtoWtlOGmsAF6JDzLkc=";
  };
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ];
  nativeBuildInputs = [
    pkg-config
  ];
  npmDepsHash = "sha256-zXhWtPuiu+CRk712KskuHP4vglogJmFoCak6qWczPFM=";
  npmInstallFlags = [ "--include=dev" ];
  npmBuildScript = "build:cli";
  postPatch = ''
    ${lib.getExe buildPackages.jq} '
      .scripts.postinstall |= empty |     # tries to install playwright, not necessary for build
      .name |= "vscode-solidity-server" |
      .bin |= "./dist/cli/server.js"      # there is no bin output defined
    ' ${src}/package.json > package.json
  '';

  preBuild = ''
    export PATH="node_modules/.bin:$PATH"
  '';
  passthru.updateScript = nix-update-script { };
  makeCacheWritable = true;
  meta = with lib; {
    description = "Solidity support for Visual Studio code";
    homepage = "https://github.com/juanfranblanco/vscode-solidity";
    mainProgram = "vscode-solidity-server";
    license = licenses.mit;
    maintainers = with maintainers; [ zeorin ];
  };
}
