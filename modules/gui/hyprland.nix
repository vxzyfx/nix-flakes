{pkgs, vars, lib, options, config, ...}:

with lib;
let
  cfg = config.modules.gui.hyprland;
in
{
  options.modules.gui.hyprland = {
    enable = mkEnableOption "Linux系统下的平铺窗口管理器";
  };
  config = vars.onlyLinuxOptionalAttrs (mkIf cfg.enable {
    modules.gui.input.fcitx5.enable = mkDefault true;
    services.udev = {
      enable = true;
      extraRules = ''
       RUN+="${pkgs.coreutils-full}/bin/chgrp wheel /sys/class/backlight/intel_backlight/brightness"
       RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness" 
      '';
    };
    services.pipewire = {
      enable = mkDefault true;
      pulse.enable = mkDefault true;
    };
    services.libinput.enable = mkDefault true;
    services.seatd.enable = mkDefault true;
    security.polkit.enable = mkDefault true;
    programs.hyprland.enable = mkDefault true;
    programs.uwsm = {
      enable = mkDefault true;
      waylandCompositors.hyprland = {
        binPath = "/run/current-system/sw/bin/Hyprland";
        comment = "uwsm 管理Hyprland会话";
        prettyName = "Hyprland";
      };
    };
  });
}
