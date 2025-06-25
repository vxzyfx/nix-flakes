{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.nnn;
in
{
  options.home-modules.nnn = {
    enable = mkEnableOption "nnn文件管理器";
    package = mkOption {
      type = types.package;
      description = "nnn软件包";
      default = pkgs.nnn.override { withNerdIcons = true; };
    };
  };
  config = mkIf cfg.enable {
    programs.nnn = {
      enable = true;
      package = cfg.package;
    };
  };
}
