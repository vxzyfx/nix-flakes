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
      extraConfig = ''
        set -g status off
      '';
    };
  };
}
