{
  pkgs,
  lib,
  config,
  vars,
  ...
}: 
with lib;

let
  cfg = config.modules.nixos.sing-box;
in {
  options.modules.nixos.sing-box = {
    enable = mkEnableOption "sing-box代理";
    package = lib.mkPackageOption pkgs "sing-box" { };
    group = mkOption {
      default = "sing-box";
      type = types.str;
      example = "sing-box";
      description = ''
        设置sing-box运行的用户组
      '';
    };
    dataDir = mkOption {
      default = "/var/lib/sing-box";
      type = types.path;
      description = ''
        sing-box数据目录
      '';
    };
    configFile = mkOption {
      default = "/etc/sing-box/config.json";
      type = types.path;
      description = ''
        sing-box配置文件
      '';
    };
  };
  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.sing-box = {
      serviceConfig = {
        StateDirectory = "sing-box";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "sing-box";
        RuntimeDirectoryMode = "0700";
        Group = cfg.group;
        ReadWritePaths = [ cfg.dataDir ];
        ExecStart = [
          ""
          "${lib.getExe cfg.package} -D ${cfg.dataDir} -c ${cfg.configFile} run"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };
    users.users.sing-box = {
      group = "sing-box";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };
    users.groups.sing-box = { };
  };
}
