{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.nix;
  system = config.modules.system;
in
{
  options.modules.nix = {
    flakes.enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "nix开启flakes";
    };
    gc.enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "nix开启gc";
    };
  };
  config = mkMerge [
    (mkIf cfg.flakes.enable {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    })
    (vars.onlyDarwinOptionalAttrs (
      mkIf cfg.gc.enable {
        nix.gc.automatic = mkForce true;
        nix.gc.interval = mkDefault [
          {
            Weekday = 7;
          }
        ];
        nix.gc.options = mkDefault "--delete-older-than 7d";
        nix.optimise.automatic = mkDefault true;
        nix.optimise.interval = mkDefault [
          {
            Weekday = 7;
          }
        ];
      }
    ))
    (vars.onlyLinuxOptionalAttrs (
      mkIf cfg.gc.enable {
        nix.gc.automatic = mkDefault true;
        nix.gc.dates = mkDefault "weekly";
        nix.gc.options = mkDefault "--delete-older-than 7d";
        nix.optimise.automatic = mkDefault true;
      }
    ))
  ];
}
