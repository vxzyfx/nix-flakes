{
  pkgs,
  lib,
  config,
  vars,
  ...
}: 
with lib;

let
  cfg = config.modules.nixos.tmp;
in {
  options.modules.nixos.tmp = {
    enable = mkOption {
      type = types.bool;
      default = true;
      example = true;
      description = "启用tmpfs";
    };
    size = mkOption {
      type = types.str;
      default = "60%";
      example = "60%";
      description = "tmpfs使用的百分比";
    };
  };
  config = mkIf cfg.enable {
    boot.tmp.useTmpfs = mkDefault true;
    boot.tmp.tmpfsSize = mkDefault cfg.size;
  };
}
