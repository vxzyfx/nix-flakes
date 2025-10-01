{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.home-modules.desktop;
in
{
  options.home-modules.desktop = {
    enable = mkEnableOption "启用Desktop配置";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      acpilight
    ];
    home-modules.launcher.fuzzel.enable = mkDefault true;
    home-modules.mako.enable = mkDefault true;
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };
}
