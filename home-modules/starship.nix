{
  pkgs,
  lib,
  config,
  systemModules,
  ...
}:
with lib;

let
  cfg = config.home-modules.starship;
in {
  options.home-modules.starship = {
    enable = mkEnableOption "shell提示";
    enableBashIntegration = mkEnableOption "集成bash";
    enableZshIntegration = mkEnableOption "集成zsh";
  };
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = mkDefault cfg.enableBashIntegration;
      enableZshIntegration = mkDefault cfg.enableZshIntegration;
      settings = {
        add_newline = false;
        command_timeout = 1000;
        battery = {
          disabled=true;
        };
      };
    };
  };
}
