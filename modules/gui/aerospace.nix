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
          inner.horizontal = 3;
          inner.vertical = 3;
          outer.left = 6;
          outer.bottom = 6;
          outer.top = 6;
          outer.right = 6;
        };
        mode.main.binding = {
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";
          alt-f = "layout floating tiling";
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";
          alt-shift-minus = "resize smart -50";
          alt-shift-equal = "resize smart +50";
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
          alt-w = "workspace W";
          alt-b = "workspace B";
          alt-t = "workspace T";
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
          alt-shift-w = "move-node-to-workspace W";
          alt-shift-b = "move-node-to-workspace B";
          alt-shift-t = "move-node-to-workspace T";
          alt-leftSquareBracket = "workspace --wrap-around prev";
          alt-rightSquareBracket = "workspace --wrap-around next";
          alt-tab = "workspace-back-and-forth";
          alt-shift-f = "fullscreen";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          alt-shift-semicolon = "mode service";
          alt-r = "mode resize";
          alt-enter = "exec-and-forget ${pkgs.kitty}/bin/kitty -d ~";
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
        mode.resize.binding = {
          minus = "resize smart -50";
          equal = "resize smart +50";
          esc = "mode main";
        };
        on-focus-changed = [
          "move-mouse window-lazy-center"
        ];
        # on-window-detected = [
        #  "if.app-id = 'com.google.Chrome' run = 'move-node-to-workspace B'"
        #  "if.app-id = 'org.mozilla.firefox' run = 'move-node-to-workspace B'"
        # ];
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
