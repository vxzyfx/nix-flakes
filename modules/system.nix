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
  options.modules.system = {
    stateVersion = mkOption {
      type = types.str;
      default = "24.05";
      example = "24.05";
      description = "特定计算机上安装的 NixOS 的第一个版本";
    };
    darwinStateVersion = mkOption {
      type = types.ints.between 1 config.system.maxStateVersion;
      default = 5;
      example = 5;
      description = "特定计算机上安装的 nix-darwin 的第一个版本";
    };
    hostname = mkOption {
      type = types.str;
      default = vars.hostname;
      example = "localhost";
      description = "主机名";
    };
    editor = mkOption {
      type = types.str;
      default = "vim";
      example = "vim";
      description = "默认编辑器";
    };
    allowUnfree = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "允许安装非自由软件";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Asia/Shanghai";
      example = "Asia/Shanghai";
      description = "系统时区";
    };
    isDarwin = mkOption {
      type = types.bool;
      default = vars.isDarwin;
      example = false;
      description = "判断是否是Darwin系统";
    };
    isLinux = mkOption {
      type = types.bool;
      default = vars.isLinux;
      example = false;
      description = "判断是否是Linux系统";
    };
  };
  config = mkMerge [
    (vars.onlyDarwinOptionalAttrs {
      services.nix-daemon.enable = mkDefault true;
      networking.computerName = mkDefault cfg.hostname;
      system.defaults.smb.NetBIOSName = mkDefault cfg.hostname;
      system.stateVersion = mkDefault cfg.darwinStateVersion;
    })
    (vars.onlyLinuxOptionalAttrs {
      system.stateVersion = mkDefault cfg.stateVersion;
      i18n.defaultLocale = mkDefault "en_US.UTF-8";
      i18n.supportedLocales = mkDefault [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];
    })
    {
      time.timeZone = mkDefault cfg.timeZone;
      environment.variables.EDITOR = cfg.editor;
      nixpkgs.config.allowUnfree = mkDefault cfg.allowUnfree;
      networking.hostName = mkDefault cfg.hostname;
    }
  ];
}
