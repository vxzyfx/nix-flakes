{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.waybar;
in
{
  options.home-modules.waybar = {
    enable = mkEnableOption "高度可定制的 Wayland 状态栏";
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 26;
          spacing = 4;
          modules-left = [
            "hyprland/workspaces"
            "idle_inhibitor"
            "wireplumber"
            "backlight"
            "network"
          ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "cpu"
            "memory"
            "temperature"
            "battery"
            "clock"
          ];
          "hyprland/workspaces" = {
            format = "{}";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          wireplumber = {
            format = "{volume}% {icon}";
            format-muted = "";
            format-icons = [
              ""
              ""
              ""
            ];
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            max-volume = 150;
            scroll-step = 0.2;
          };
          backlight = {
            format = "{percent}% {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%)  ";
            format-ethernet = "{ipaddr}/{cidr} 󰱓 ";
            tooltip-format = "{ifname} via {gwaddr} 󰲝 ";
            format-linked = "{ifname} (No IP) 󰅛 ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname} : {ipaddr}/{cidr}";
          };
          "hyprland/window" = {
            format = "{}";
            separate-outputs = true;
          };
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          memory = {
            format = "{}% ";
          };
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = [
              ""
              ""
              ""
            ];
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% {icon}";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-good = "";
            format-full = "";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          clock = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
        };
      };
      style = ''
        @define-color base00 #181818;
        @define-color base01 #2b2e37;
        @define-color base02 #3b3e47;
        @define-color base03 #585858;
        @define-color base04 #b8b8b8;
        @define-color base05 #d8d8d8;
        @define-color base06 #e8e8e8;
        @define-color base07 #f8f8f8;
        @define-color base08 #ab4642;
        @define-color base09 #dc9656;
        @define-color base0A #f7ca88;
        @define-color base0B #a1b56c;
        @define-color base0C #86c1b9;
        @define-color base0D #7cafc2;
        @define-color base0E #ba8baf;
        @define-color base0F #a16946;

        * {
          transition: none;
          box-shadow: none;
        }

        #waybar {
          font-family: 'JetBrainsMono Nerd Font', sans-serif;
          font-size: 12px;
          font-weight: 400;
          color: @base04;
          background: @base01;
        }

        #workspaces {
          margin: 0 4px;
        }

        #workspaces button {
          margin: 0px 0;
          padding: 0 4px;
          color: @base05;
        }

        #workspaces button.visible {
        }

        #workspaces button.active {
          border-radius: 4px;
          background-color: @base02;
        }

        #workspaces button.urgent {
          color: rgba(238, 46, 36, 1);
        }

        #mode, #battery, #cpu, #memory, #network, #wireplumber, #idle_inhibitor, #backlight, #clock, #temperature {
          margin: 0px 2px;
          padding: 0 6px;
          background-color: @base02;
          border-radius: 4px;
          min-width: 20px;
        }

        #wireplumber.muted {
          color: @base0F;
        }

        #clock {
          margin-left: 0px;
          margin-right: 4px;
          background-color: transparent;
        }

        #temperature.critical {
          color: @base0F;
        }

        #window {
          font-weight: 400;
          font-family: sans-serif;
        }
      '';
    };
  };
}
