{ mylib, lib, ... }:
let
  args = {
    inherit mylib lib;
  };
  vars = lib.attrsets.mapAttrs' (
    n: v:
    let
      value = mylib.importNix args v;
      name = value.hostname or n;
    in
    lib.attrsets.nameValuePair name value
  ) (mylib.loadVars ./.);
in
vars
