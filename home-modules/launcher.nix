{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.launcher;
in
{
  options.home-modules.launcher = {
    fuzzel.enable = mkEnableOption "Wayland 通知守护进程";
  };
  config = mkMerge [
    (mkIf cfg.fuzzel.enable {
      programs.fuzzel = {
        enable = true;
      };
    })
  ];
}
