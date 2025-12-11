{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.modules.nixos.nspawn;
in
{
  options.modules.nixos.nspawn = mkOption {
    type =
      with lib.types;
      attrsOf (
        submodule (
          {
            name,
            ...
          }:
          {
            options = {
              enable = mkEnableOption "systemd nspawn start on boot";
              execConfig = mkOption {
                default = { };
                type = attrs;
              };
              filesConfig = mkOption {
                default = { };
                type = attrs;
              };
              networkConfig = mkOption {
                default = { };
                type = attrs;
              };
            };
          }
        )
      );
  };
  config = mkIf (cfg != { }) {
    systemd.services = lib.attrsets.mapAttrs' (n: v: {
      name = "systemd-nspawn@${n}";
      value = {
        wantedBy = [ "machines.target" ];
        overrideStrategy = "asDropin";
      };
    }) (attrsets.filterAttrs (_: v: v.enable) cfg);

    systemd.nspawn = lib.attrsets.mapAttrs' (n: v: {
      name = n;
      value = {
        inherit (v) execConfig filesConfig networkConfig;
      };
    }) cfg;
  };
}
