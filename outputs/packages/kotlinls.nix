{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk,
  unar,
}:
let
  isDarwin = stdenvNoCC.hostPlatform.isDarwin;
  version = "271.2085.0";
  src =
    {
      aarch64-darwin = {
        url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}-aarch64.sit";
        hash = "sha256-LSI4j1i+b036eo8YweIxhxFk3KzBbkB1WQKdcjKBa0o=";
      };
      x86_64-linux = {
        url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.tar.gz";
        hash = "sha256-45jnmQJ/QXSeoz+qV0cDB9E9QPkQlhhYx+MK29d4rgg=";
      };
    }
    .${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit version;
  pname = "kotlin-lsp";
  src = fetchurl {
    url = src.url;
    hash = src.hash;
  };
  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals isDarwin [ unar ];

  unpackPhase = ''
    runHook preUnpack

    ${
      if isDarwin then
        ''
          unar -f -D -k hidden -o . "$src"
        ''
      else
        ''
          tar -xzf "$src"
        ''
    }
    runHook postUnpack
  '';
  installPhase = ''
    mkdir -p $out
    cp -R kotlin-server-$version/* "$out"
    chmod +x $out/kotlin-lsp.sh
    patchShebangs "$out/kotlin-lsp.sh"
    makeWrapper $out/kotlin-lsp.sh $out/bin/kotlin-lsp --set JAVA_HOME ${jdk}
  '';
  meta = with lib; {
    description = "Kotlin Language Server and plugin for Visual Studio Code";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    mainProgram = "kotlin-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ zeorin ];
  };
})
