{lib, ...}: 
let
  findNixFileAndDir = path:
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory")
            || (
              (path != "default.nix")
              && (lib.strings.hasSuffix ".nix" path)
            )
        )
        (builtins.readDir path)));
in
{
  darwinSystem = import ./darwinSystem.nix;
  nixosSystem = import ./nixosSystem.nix;

  importNix = args: i: let f = import i; mod = if builtins.isFunction f then f args else f; in mod;
  relativeToRoot = lib.path.append ../.;
  loadVars = path: builtins.listToAttrs (lib.lists.forEach (findNixFileAndDir path) (v: lib.attrsets.nameValuePair (lib.strings.removeSuffix ".nix" v) ( path + "/${v}")));
  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (findNixFileAndDir path);
}
