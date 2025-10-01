{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.niri;
  niriConfig = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
        }
    }
    ${lib.concatLines outpus}

    layout {
        gaps 6

        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 1.0; }
        focus-ring {
            width 2
            active-color "#7fc8ff"
            inactive-color "#505050"
        }

        border {
            off
        }

        shadow {
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
        }
        struts {
        }
    }
    hotkey-overlay {
        skip-at-startup
    }

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"
    prefer-no-csd

    animations {
    }
    gestures {
        hot-corners {
            off
        }
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+T hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty"; }
        Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }
        Mod+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
        XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

        XF86MonBrightnessUp allow-when-locked=true { spawn "xbacklight" "-inc" "5"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "xbacklight" "-dec" "5"; }

        Mod+O repeat=false { toggle-overview; }

        Mod+Q repeat=false { close-window; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        Mod+Ctrl+F { expand-column-to-available-width; }

        Mod+C { center-column; }

        Mod+Ctrl+C { center-visible-columns; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+V       { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        Mod+W { toggle-column-tabbed-display; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete { quit; }

        Mod+Shift+P { power-off-monitors; }
    }
  '';
  niriOutputConfig =
    { ... }:
    {
      options = {
        mode = mkOption {
          type = types.str;
          description = "显示器模式";
          default = "1920x1080@60";
        };
        scale = mkOption {
          type = types.float;
          description = "显示器缩放";
          default = 1.0;
        };
        transform = mkOption {
          type = types.str;
          description = "显示器偏移";
          default = "normal";
        };
        position = {
          x = mkOption {
            type = types.int;
            description = "显示器x位置";
            default = 0;
          };
          y = mkOption {
            type = types.int;
            description = "显示器y位置";
            default = 0;
          };
        };
      };

    };
  outpus = lib.attrsets.mapAttrsToList (name: value: ''
    output "${name}" {
        mode "${value.mode}"
        scale ${builtins.toString value.scale}
        transform "${value.transform}"
        position x=${builtins.toString value.position.x} y=${builtins.toString value.position.y}
        focus-at-startup
    }
  '') cfg.outputs;
in
{
  options.home-modules.niri = {
    enable = mkEnableOption "niri wayland window manager";
    package = mkOption {
      type = types.package;
      description = "niri";
      default = pkgs.niri;
    };
    bg = mkOption {
      type = types.path;
      description = "桌面背景图片";
    };
    outputs = lib.mkOption {
      type = with lib.types; attrsOf (submodule niriOutputConfig);
      default = { };
      description = "定义显示器参数";
    };
    systemd = {
      enable = mkEnableOption "niri systemd";
    };
  };
  config = mkIf cfg.enable {

    home-modules.desktop.enable = mkDefault true;
    home.packages = [
      cfg.package
      pkgs.polkit_gnome
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.gnome-keyring
      pkgs.swaylock
    ];
    xdg.configFile."niri/config.kdl" = {
      text = lib.optionalString cfg.systemd.enable niriConfig;
    };
    systemd.user.services = mkIf cfg.systemd.enable {
      mako = {
        Unit = {
          Description = "Lightweight Wayland notification daemon";
          Documentation = "man:mako(1)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ConditionEnvironment = "WAYLAND_DISPLAY";
          ExecStart = "${lib.getExe pkgs.mako}";
          ExecReload = "${lib.getExe pkgs.mako} reload";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      swaybg = {
        Unit = {
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = "graphical-session.target";
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${cfg.bg}";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      swayidle = {
        Unit = {
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = "graphical-session.target";
        };
        Service = {
          Restart = "on-failure";
          ExecStart = "${lib.getExe pkgs.swayidle} -w timeout 601 '${lib.getExe cfg.package} msg action power-off-monitors' timeout 600 '${lib.getExe pkgs.swaylock} -f' before-sleep '${lib.getExe pkgs.swaylock} -f'";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
