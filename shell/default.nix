{ pkgs, ... }@args: 
let
  findNixFile =
    path:
    (builtins.attrNames (
      pkgs.lib.attrsets.filterAttrs (
        path: _type:
        (_type != "directory") && ((path != "default.nix") && (pkgs.lib.strings.hasSuffix ".nix" path))
      ) (builtins.readDir path)
    ));
  files = findNixFile ./.;
  shellsList = builtins.map ( item: let name = pkgs.lib.strings.removeSuffix ".nix" item; value = import ./${item} args; in { "${name}" = value;  }) files;
  shells = pkgs.lib.attrsets.mergeAttrsList shellsList;
in
  shells
