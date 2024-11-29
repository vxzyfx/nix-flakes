{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.tui.sops;
in
{
  options.modules.tui.sops = {
    enable = mkEnableOption "sops软件";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sops
    ];
  };
}
