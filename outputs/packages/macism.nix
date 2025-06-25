{ lib
, swiftPackages
, fetchFromGitHub
, nix-update-script
, swift
, ...
} @ args:
let
  stdenv = swiftPackages.stdenv;
in
stdenv.mkDerivation rec {
  pname = "macism";
  version = "3.0.10";
  src = fetchFromGitHub ({
    owner = "laishulu";
    repo = "macism";
    tag = "v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-TNZoVCGbWYZHWL1hgdq9p+RrbsWLtL8FuNpf0OvN+uM=";
  });
  nativeBuildInputs = [ swift ];
  buildPhase = "make macism";
  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 macism $out/bin
  '';
  passthru = {
    updateScript = nix-update-script { };
  };
  meta = {
    homepage = "https://github.com/laishulu/macism";
    description = "Reliable CLI MacOS Input Source Manage";
    license = lib.licenses.mit;
    mainProgram = "macism";
    platforms = [
      "aarch64-darwin"
    ];
  };
}
