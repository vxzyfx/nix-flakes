{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  jdk,
}:
let
  system =
    {
      aarch64-darwin = "mac-aarch64";
      x86_64-linux = "linux-x64";
    }
    .${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "261.13587.0";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${finalAttrs.version}/kotlin-lsp-${finalAttrs.version}-${system}.zip";
    stripRoot = false;
    hash = "sha256-zwlzVt3KYN0OXKr6sI9XSijXSbTImomSTGRGa+3zCK8=";
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
