{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.kitty;
in
{
  options.home-modules.kitty = {
    enable = mkEnableOption "kitty终端软件";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMonoNL Nerd Font Mono";
      };
      themeFile = "tokyo_night_moon";
      extraConfig = ''
        mouse_map left click ungrabbed
      '';
      settings = {
        term = "xterm-256color";
        allow_hyperlinks = "no";
        hide_window_decorations = "yes";
        macos_quit_when_last_window_closed = "yes";
        window_padding_width = 6;
        clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      };
    };
  };
}
