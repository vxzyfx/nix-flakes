{
  lib,
  inputs,
  myvars,
  hostname,
  system,
  genSpecialArgs,
  overlays ? [],
  specialArgs ? (genSpecialArgs system hostname),
  ...
}:
let
  inherit (inputs) home-manager nix-darwin;
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
  darwinModules = vars.modules or { };
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = (specialArgs // { vars = (specialArgs.vars // { inherit enableHomeManager; }); });
  modules = [
    darwinModules
    ../modules
    ({ pkgs, ... }: { nixpkgs.overlays = overlays; })
  ];
}
