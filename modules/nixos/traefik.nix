{
  pkgs,
  lib,
  config,
  vars,
  ...
}: 
with lib;

let
  cfg = config.modules.nixos.traefik;
  jsonValue = with types;
    let
      valueType = nullOr (oneOf [
        bool
        int
        float
        str
        (lazyAttrsOf valueType)
        (listOf valueType)
      ]) // {
        description = "JSON value";
        emptyValue.value = { };
      };
    in valueType;
in {
  options.modules.nixos.traefik = {
    enable = mkEnableOption "HTTP服务器";
    package = mkPackageOption pkgs "traefik" { };
    staticConfigOptions = mkOption {
      description = ''
        端点等静态配置
      '';
      type = jsonValue;
      default = { entryPoints.http.address = ":80"; };
      example = {
        entryPoints.web.address = ":8080";
        entryPoints.http.address = ":80";
        api = { };
      };
    };
    dynamicConfigFile = mkOption {
      default = null;
      example = literalExpression "/path/to/dynamic_config.toml";
      type = types.nullOr types.path;
      description = ''
        路由,中间件等的配置
      '';
    };
    dataDir = mkOption {
      default = "/var/lib/traefik";
      type = types.path;
      description = ''
        traefik的数据目录
      '';
    };
    environmentFiles = mkOption {
      default = [];
      type = types.listOf types.path;
      example = [ "/run/secrets/traefik.env" ];
      description = ''
        systemd的环境变量文件
      '';
    };
  };
  config = mkIf cfg.enable {
    services.traefik = {
      enable = true;
      package = cfg.package;
      staticConfigOptions = cfg.staticConfigOptions;
      dynamicConfigFile = cfg.dynamicConfigFile;
      dataDir = cfg.dataDir;
      environmentFiles = cfg.environmentFiles;
    };
  };
}

