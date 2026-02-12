{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.tmux;
in
{
  options.home-modules.tmux = {
    enable = mkEnableOption "启用tmux";
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      escapeTime = 0;
      extraConfig = ''
        set -g status off
        set -g allow-passthrough on
        set -s set-clipboard on
      '';
    };
  };
}
