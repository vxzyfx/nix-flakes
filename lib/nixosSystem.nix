{
  lib,
  inputs,
  myvars,
  hostname,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system hostname),
  ...
}:
let
  inherit (inputs) nixpkgs home-manager;
  vars = specialArgs.vars;
  users = vars.users or { };
  userNames = builtins.attrNames users;
  userValues = builtins.attrValues users;
  userEnableHomeManager = builtins.any (
    v:
    let
      active = v.enableHomeManager or true;
    in
    active
  ) userValues;
  hasUsers = (builtins.length userNames) != 0;
  enableHomeManager = userEnableHomeManager && hasUsers;
  nixosModules = vars.modules or { };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = (specialArgs // { vars = (specialArgs.vars // { inherit enableHomeManager; }); });
  modules = [
    nixosModules
    ../modules
  ];
}
