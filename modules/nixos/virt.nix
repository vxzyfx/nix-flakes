{
  pkgs,
  lib,
  config,
  vars,
  ...
}: 
with lib;

let
  cfg = config.modules.nixos.virt;
in {
  options.modules.nixos.virt = {
    enable = mkEnableOption "开启kvm虚拟化";
  };
  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
            packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    environment.systemPackages = with pkgs; [
      virt-manager
    ];
  };
}
