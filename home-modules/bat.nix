{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.bat;
in
{
  options.home-modules.bat = {
    enable = mkEnableOption "启用bat";
  };
  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
    };
  };
}
