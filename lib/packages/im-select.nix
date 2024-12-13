{
  stdenv,
  fetchurl,
  lib,
  callPackage,
  ...
}@args:
let
  arch =
    {
      "aarch64-darwin" = "apple";
      "x86_64-darwin" = "intel";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "im-select";
  version = "1.0.1";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/daipeihust/im-select/master/macOS/out/${arch}/im-select";
    sha256 = "sha256-MbBlL421nvBpBs1qhjXcweYWKILoMAytSCqLW5f/8pA=";
  };
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D $src $out/bin/im-select
  '';
  meta = {
    changelog = "https://github.com/daipeihust/im-select";
    description = "在 shell 中切换输入法";
    homepage = "https://github.com/daipeihust/im-select";
    platforms = lib.platforms.darwin;
    mainProgram = "im-select";
  };
}
