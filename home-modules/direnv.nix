{
  pkgs,
  lib,
  config,
  systemModules,
  ...
}:
with lib;

let
  cfg = config.home-modules.direnv;
in {
  options.home-modules.direnv = {
    enable = mkEnableOption "环境切换器direnv";
    enableBashIntegration = mkEnableOption "集成bash";
    enableZshIntegration = mkEnableOption "集成zsh";
  };
  config = mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = mkDefault cfg.enableBashIntegration;
        enableZshIntegration = mkDefault cfg.enableZshIntegration;
        nix-direnv.enable = true;
      };
    };
  };
}
