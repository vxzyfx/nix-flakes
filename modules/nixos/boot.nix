{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.nixos.boot;
in
{
  options.modules.nixos.boot = {
    systemd.enable = mkEnableOption "systemd-boot启动";
    grub.enable = mkEnableOption "grub启动";
    grub.device = mkOption {
      type = types.str;
      description = "grub启动硬盘, 如/dev/vda1";
    };
  };
  config = mkMerge [
    (mkIf cfg.systemd.enable {
      boot.loader.systemd-boot.enable = mkDefault true;
      boot.loader.systemd-boot.configurationLimit = mkDefault 5;
      boot.loader.efi.canTouchEfiVariables = mkDefault true;
    })
    (mkIf cfg.grub.enable {
      boot.loader.grub.enable = mkDefault true;
      boot.loader.grub.device = mkDefault cfg.grub.device;
      boot.loader.grub.configurationLimit = 5;
    })
  ];
}
