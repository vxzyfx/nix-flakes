{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.home-modules.gpg;
in
{
  options.home-modules.gpg = {
    enable = mkEnableOption "启用gpg";
    agent = {
      enable = mkEnableOption "启用gpg agent";
      enableSshSupport = mkEnableOption "启用gpg agent ssh";
      shellIntegration = mkEnableOption "启用gpg agent shell integration";
      pinentryPackage = mkPackageOption pkgs "pinentry-curses" {
        example = "pkgs.pinentry-curses";
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.gpg = {
        enable = true;
      };
    }
    {
      services.gpg-agent = {
        enable = cfg.agent.enable;
        enableSshSupport = cfg.agent.enableSshSupport;
        enableBashIntegration = cfg.agent.shellIntegration;
        enableZshIntegration = cfg.agent.shellIntegration;
        enableFishIntegration = cfg.agent.shellIntegration;
        pinentry.package = cfg.agent.pinentryPackage;
      };
      home-modules.gpg.agent.enableSshSupport = mkDefault true;
      home-modules.gpg.agent.shellIntegration = mkDefault true;
    }
  ]);
}
