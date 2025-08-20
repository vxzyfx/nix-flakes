final: prev:
let
  callPackage = pname: final.callPackage ./packages/${pname}.nix { };
  packages = [
    "macism"
    "sing-box"
    "kulala-ls"
    "kotlinls"
    "vscode-solidity-server"
  ];
  attrs = builtins.listToAttrs (
    builtins.map (v: {
      name = v;
      value = callPackage v;
    }) packages
  );
in
attrs
