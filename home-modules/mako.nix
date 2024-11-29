{
  pkgs,
  lib,
  config,
  systemModules,
  ...
}:
with lib;

let
  cfg = config.home-modules.mako;
in
{
  options.home-modules.mako = {
    enable = mkEnableOption "Wayland 通知守护进程";
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      font = "monospace 10";
      width = 350;
      padding = "10";
      margin = "10";
      borderSize = 2;
      borderRadius = 8;
      backgroundColor = "#1d202f";
      borderColor = "#f7768e";
      textColor = "#c0caf5";
      defaultTimeout = 3000;
    };
  };
}
