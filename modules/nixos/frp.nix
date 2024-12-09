{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.nixos.frp;
in
{
  options.modules.nixos.frp = {
    enableServer = mkEnableOption "frp服务端";
    enableClient = mkEnableOption "frp客户端";
    package = lib.mkPackageOption pkgs "frp" { };
    serverConfigFile = mkOption {
      default = "/etc/frp/frps.toml";
      type = types.str;
      description = ''
        frps配置文件
      '';
    };
    clientConfigFile = mkOption {
      default = "/etc/frp/frpc.toml";
      type = types.str;
      description = ''
        frpc配置文件
      '';
    };
  };
  config = mkMerge [
    (mkIf cfg.enableServer {
      systemd.packages = [ cfg.package ];
      systemd.services.frps = {
        serviceConfig = {
          ExecStart = [
            "${cfg.package}/bin/frps -c ${cfg.serverConfigFile}"
          ];
        };
        wantedBy = [ "multi-user.target" ];
      };
    })
    (mkIf cfg.enableClient {
      systemd.packages = [ cfg.package ];
      systemd.services.frpc = {
        serviceConfig = {
          ExecStart = [
            "${cfg.package}/bin/frpc -c ${cfg.clientConfigFile}"
          ];
        };
        wantedBy = [ "multi-user.target" ];
      };
    })
  ];
}
