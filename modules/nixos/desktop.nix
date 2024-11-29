{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.nixos.desktop;
in
{
  options.modules.nixos.desktop = {
    enable = mkEnableOption "nixos桌面环境";
  };
  config = mkIf cfg.enable {
    modules.gui.font.yahei.enable = mkDefault true;
    modules.gui.hyprland.enable = mkDefault true;
    environment.systemPackages = with pkgs; [
      (google-chrome.override {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";
      })
    ];
    programs.firefox = {
      enable = mkDefault true;
    };
  };
}
