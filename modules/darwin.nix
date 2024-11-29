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
in
{
  config = vars.onlyDarwinOptionalAttrs (
    mkIf cfg.isDarwin {
      system.defaults = {
        dock.autohide = true;
        hitoolbox.AppleFnUsageType = "Change Input Source"; # Fn键修改输入法
        finder = {
          _FXShowPosixPathInTitle = true;
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          ShowStatusBar = true;
        };
        trackpad = {
          Clicking = true; # 轻触触摸板相当于点击
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
        };
      };
    }
  );
}
