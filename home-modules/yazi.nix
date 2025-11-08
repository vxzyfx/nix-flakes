{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.yazi;
in
{
  options.home-modules.yazi = {
    enable = mkEnableOption "启用yazi";
  };
  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
