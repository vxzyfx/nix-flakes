{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.modules.nixos.ld;
in
{
  options.modules.nixos.ld = {
    enable = mkOption {
      type = types.bool;
      default = true;
      example = true;
      description = "启用nix-ld";
    };
    libraries = mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "nix-ld包含的库";
    };
  };
  config = mkIf cfg.enable {
    programs.nix-ld.enable = mkDefault true;
    programs.nix-ld.libraries = cfg.libraries;
  };
}
