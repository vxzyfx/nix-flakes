{
  pkgs,
  vars,
  lib,
  options,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.gui.aerospace;
in
{
  options.modules.gui.aerospace = {
    enable = mkEnableOption "Mac系统下的平铺窗口管理器";
    settingsExtra = lib.mkOption {
      type = types.attrs;
      default = { };
      description = ''
        AeroSpace配置
        <link xlink:href="https://nikitabobko.github.io/AeroSpace/guide#configuring-aerospace"/>
      '';
    };
    settings = options.services.aerospace.settings // {
      default = {
        gaps = {
          inner.horizontal = 2;
          inner.vertical = 2;
          outer.left = 2;
          outer.bottom = 2;
          outer.top = 2;
          outer.right = 2;
        };
        mode.main.binding = {
          alt-w = "layout accordion horizontal vertical";
          alt-comma = "layout tiles vertical";
          alt-period = "layout tiles horizontal";
          alt-shift-q = "close";
          alt-v = "layout floating tiling";
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";
          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 0";
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-0 = "move-node-to-workspace 0";
          alt-i = "workspace --wrap-around prev";
          alt-u = "workspace --wrap-around next";
          alt-tab = "workspace-back-and-forth";
          alt-shift-f = "fullscreen";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          alt-shift-semicolon = "mode service";
          alt-t = "exec-and-forget ${pkgs.kitty}/bin/kitty -d ~";
        };
        mode.service.binding = {
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];
          alt-shift-h = [
            "join-with left"
            "mode main"
          ];
          alt-shift-j = [
            "join-with down"
            "mode main"
          ];
          alt-shift-k = [
            "join-with up"
            "mode main"
          ];
          alt-shift-l = [
            "join-with right"
            "mode main"
          ];
        };
        on-window-detected = [
          {
            check-further-callbacks = false;
            "if" = {
              app-id = "com.google.Chrome";
            };
            run = [
              "move-node-to-workspace 6"
            ];
          }
          {
            check-further-callbacks = false;
            "if" = {
              app-id = "com.apple.finder";
            };
            run = [
              "layout floating"
            ];
          }
        ];
      };
    };
  };
  config = vars.onlyDarwinOptionalAttrs (
    mkIf cfg.enable {
      services.aerospace = {
        enable = mkDefault true;
        settings = mkDefault (mkMerge [
          cfg.settings
          cfg.settingsExtra
        ]);
      };
    }
  );
}
