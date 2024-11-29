{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.nixos.logid;
in
{
  options.modules.nixos.logid = {
    enable = mkEnableOption "Logitech 设备驱动程序";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      logiops
    ];
    systemd.services.logid = {
      serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/logid";
      };
      wantedBy = [ "graphical.target" ];
    };
    environment.etc."logid.cfg".text = ''
      devices: (
      {
          name: "MX Master 3S";
          smartshift:
          {
              on: false;
              threshold: 30;
              torque: 50;
          };
          hiresscroll:
          {
              hires: false;
              invert: false;
              target: false;
          };
          dpi: 1000;

          buttons: (
              {
                  cid: 0xc3;
                  action =
                  {
                      type: "Gestures";
                      gestures: (
                          {
                              direction: "Up";
                              mode: "OnRelease";
                              action =
                              {
                                  type: "Keypress";
                                  keys: ["KEY_UP"];
                              };
                          },
                          {
                              direction: "Down";
                              mode: "OnRelease";
                              action =
                              {
                                  type: "Keypress";
                                  keys: ["KEY_DOWN"];
                              };
                          },
                          {
                              direction: "Left";
                              mode: "OnRelease";
                              action =
                              {
                                  type: "CycleDPI";
                                  dpis: [400, 600, 800, 1000, 1200, 1400, 1600];
                              };
                          },
                          {
                              direction: "Right";
                              mode: "OnRelease";
                              action =
                              {
                                  type = "ToggleHiresScroll";
                              }
                          },
                          {
                              direction: "None"
                              mode: "NoPress"
                          }
                      );
                  };
              },
              {
                  cid: 0xc4;
                  action =
                  {
                      type: "ToggleSmartshift";
                  };
              },
              {
                  cid: 0x53;
                  action =
                  {
                      type: "Keypress";
                      keys: ["KEY_LEFTMETA", "KEY_LEFTBRACE"];
                  };
              },
              {
                  cid: 0x56;
                  action =
                  {
                      type: "Keypress";
                      keys: ["KEY_LEFTMETA", "KEY_RIGHTBRACE"];
                  };
              }
          );
      }
      );
    '';
  };
}
