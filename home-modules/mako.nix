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
      settings = {
        font = "monospace 10";
        width = 350;
        padding = "10";
        margin = "10";
        border-size = 2;
        border-radius = 8;
        background-color = "#1d202f";
        border-color = "#f7768e";
        text-color = "#c0caf5";
        default-timeout = 3000;
      };
    };
  };
}
