final: prev:
let
  callPackage = pname: final.callPackage ./packages/${pname}.nix { };
in
{
  macism = callPackage "macism";
  sing-box = callPackage "sing-box";
  vscode-solidity-server = callPackage "vscode-solidity-server";
}
