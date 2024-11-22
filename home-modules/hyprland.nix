{
  pkgs,
  lib,
  config,
  systemModules,
  ...
}:
with lib;

let
  cfg = config.home-modules.hyprland;
  shell = config.home-modules.shell;
in {
  options.home-modules.hyprland = {
    enable = mkEnableOption "启用hyprland linux窗口管理器";
  };
  config = mkMerge [(mkIf cfg.enable {
    home-modules.launcher.fuzzel.enable = mkDefault true;
    home-modules.mako.enable = mkDefault true;
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
    home.packages = with pkgs;[
      acpilight
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      settings = {
        exec-once = [
          "uwsm app -- waybar"
          "uwsm app -- mako"
          "uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
        general = {
          gaps_in = 3;
          gaps_out = 6;
          border_size = 2;
          "col.active_border" = "rgba(54b2a991) rgba(ff6f69ee) 180deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
        };
        cursor = {
            inactive_timeout = 3;
        };
        decoration = {
          rounding = 4;
          active_opacity = 1.0;
          inactive_opacity = 0.8;
        
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        input = {
          kb_layout = "us";
        };
        gestures = {
          workspace_swipe = false;
        };
        animations = {
          enabled = true;
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 7, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, easeOutQuint"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };
        dwindle = {
            preserve_split = true;
        };
        "$mod" = "SUPER";
        bind =
          [
            "$mod, W, workspace, name:w"
            "$mod SHIFT, W, movetoworkspace, name:w"
            "$mod, b, workspace, name:b"
            "$mod SHIFT, B, movetoworkspace, name:b"
            "$mod, t, workspace, name:t"
            "$mod SHIFT, T, movetoworkspace, name:t"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            "$mod SHIFT, h, movewindow, l"
            "$mod SHIFT, l, movewindow, r"
            "$mod SHIFT, k, movewindow, u"
            "$mod SHIFT, j, movewindow, d"
            "$mod, bracketright, workspace, r+1"
            "$mod, bracketleft, workspace, r-1"
            "$mod SHIFT, F, fullscreen"
            "$mod, F, togglefloating"
            "$mod, mouse:272, movewindow"
            "$mod, P, pseudo," 
            "$mod, slash, togglesplit,"
            ", XF86MonBrightnessDown, exec, uwsm app -- xbacklight -dec 5"
            ", XF86MonBrightnessUp, exec, uwsm app -- xbacklight -inc 5"
            ", XF86AudioMicMute, exec, uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ", XF86AudioMute, exec, uwsm app -- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioRaiseVolume, exec, uwsm app -- wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, uwsm app -- wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
            "$mod SHIFT, z, killactive,"
            "$mod, R, exec, uwsm app -- fuzzel"
            "ALT, SPACE, exec, uwsm app -- fuzzel"
            "$mod, return, exec, uwsm app -- kitty"
          ]
          ++ (
            builtins.concatLists (builtins.genList (i:
                let ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );
      };
      extraConfig = ''
        bind=SUPER SHIFT,R,submap,resize
        submap=resize
        binde=,l,resizeactive,10 0
        binde=,h,resizeactive,-10 0
        binde=,k,resizeactive,0 -10
        binde=,j,resizeactive,0 10
        bind=,escape,submap,reset 
        submap=reset
      '';
    };
  })
  (mkIf (cfg.enable && shell.bash.enable) {
    programs.bash.profileExtra = mkBefore ''
      if [[ -z "$SSH_CONNECTION" ]]; then
        if uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      fi
    '';
  })
  (mkIf (cfg.enable && shell.zsh.enable) {
    programs.zsh.profileExtra = mkBefore ''
      if [[ -z "$SSH_CONNECTION" ]]; then
        if uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      fi
    '';
  })];
}
