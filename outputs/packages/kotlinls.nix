{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  jdk,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "0.253.10629";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${finalAttrs.version}/kotlin-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
    chmod +x $out/kotlin-lsp.sh
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
