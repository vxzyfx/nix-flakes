{
  pkgs,
  lib,
  config,
  vars,
  ...
}: 
with lib;

let
  cfg = config.modules.system;
in {
  config = vars.onlyDarwinOptionalAttrs (mkIf cfg.isDarwin {
    system.defaults = {
      dock.autohide = true;
      finder = {
          _FXShowPosixPathInTitle = true;
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          ShowStatusBar = true;
      };
      trackpad = {
          Clicking = true;  # 轻触触摸板相当于点击
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
      };
    };
  });
}
