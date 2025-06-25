{
  pkgs,
  vars,
  lib,
  options,
  config,
  ...
}:

with lib;
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCrDpZKEO9ct8HhSDCzvDwWYHYqrThawHTPJzZyACj5 vxzyfx@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1Ex2JzVSCeYhua/H4AT7GSXdwTwpSs6LSSZlklqngA shug"
  ];
  cfg = config.modules.tui.openssh;
  users = lib.attrsets.filterAttrs (
    n: v:
    let
      active = v.enableKeys or true;
    in
    active
  ) vars.users;
  defaultIncludeKeys = true;
in
{
  options.modules.tui.openssh = {
    enable = mkEnableOption "开启openssh";
    enableRootKey = mkEnableOption "添加AuthorizedKeys到root用户";
    enableKeys = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "添加密钥到用户";
    };
  };
  config = mkMerge [
    (vars.onlyLinuxOptionalAttrs (
      mkIf cfg.enable {
        services.openssh.enable = mkDefault true;
      }
    ))
    (mkIf cfg.enableRootKey {
      users.users.root.openssh.authorizedKeys.keys = lib.mkBefore keys;
    })
    (mkIf cfg.enable (
      mkMerge (
        lib.attrsets.mapAttrsToList (username: v: {
          users.users."${username}".openssh.authorizedKeys.keys = lib.mkBefore keys;
        }) users
      )
    ))
  ];
}
