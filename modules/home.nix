{
  pkgs,
  lib,
  config,
  vars,
  home-manager,
  mac-app-util,
  specialArgs,
  ...
}:
with lib;

let
  cfg = config.modules.home;
  system = config.modules.system;
  getHomeDirectory =
    username: v: v.homeDirectory or ((if vars.isDarwin then "/Users" else "/home") + "/${username}");
  home-managerModules =
    if vars.isDarwin then
      home-manager.darwinModules.home-manager
    else
      home-manager.nixosModules.home-manager;
  users = vars.users or { };
  homeUsers = lib.attrsets.filterAttrs (
    n: v:
    let
      active = v.enableHomeManager or true;
    in
    active
  ) users;
  activeHome = vars.enableHomeManager;
  homeModules = ../home-modules;
in
{
  imports = optionals activeHome [ home-managerModules ];
  options.modules.home = {
    enable = mkOption {
      type = types.bool;
      default = activeHome;
      example = false;
      description = "启用home-manager";
    };
  };
  config = mkMerge (
    [
      (mkIf cfg.enable (
        mkMerge (
          lib.attrsets.mapAttrsToList (
            username: v:
            let
              homeDirectory = getHomeDirectory username v;
            in
            {
              users.users."${username}".home = mkDefault homeDirectory;
              home-manager.users."${username}".imports = (
                [
                  homeModules
                  (
                    { lib, systemModules, ... }:
                    {
                      config = lib.mkMerge [
                        {
                          home.username = username;
                          home.homeDirectory = lib.mkDefault homeDirectory;
                          programs.home-manager.enable = true;
                          home.stateVersion = system.stateVersion;
                        }
                      ];
                    }
                  )
                  v.home-modules
                ]
                ++ vars.onlyDarwinOptionals [ mac-app-util.homeManagerModules.default ]
              );
            }
          ) homeUsers
        )
      ))
    ]
    ++ (optionals activeHome [
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs // {
          systemModules = config.modules;
        };
      }
    ])
  );
}
