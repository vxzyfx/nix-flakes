final: prev:
let
  callPackage = pname: final.callPackage ./packages/${pname}.nix { };
  packages = [
    "macism"
    "kotlinls"
    "vscode-solidity-server"
  ];
  attrs = builtins.listToAttrs (
    map (v: {
      name = v;
      value = callPackage v;
    }) packages
  );
in
attrs
// {
  # gdb = prev.gdb.overrideAttrs (
  #   finalAttrs: previousAttrs: {
  #     patches = previousAttrs.patches ++ [ gdb-patche ];
  #   }
  # );
}
