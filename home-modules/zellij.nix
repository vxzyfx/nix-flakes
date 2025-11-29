{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.zellij;
in
{
  options.home-modules.zellij = {
    enable = mkEnableOption "zellij终端复用";
    package = mkOption {
      type = types.package;
      description = "zellij软件包";
      default = pkgs.zellij;
    };
  };
  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };
  };
}
