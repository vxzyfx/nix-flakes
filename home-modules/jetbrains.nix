{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.jetbrains;
  waylandAddvmopts = package: [ (package.override { vmopts = "-Dawt.toolkit.name=WLToolkit"; }) ];
in
{
  options.home-modules.jetbrains = {
    enable = mkEnableOption "jetbrains软件";
    packages = mkOption {
      type = types.listOf types.package;
      description = "安装的jetbrains工具";
      default = with pkgs; [
        jetbrains.idea-ultimate
        jetbrains.clion
        jetbrains.pycharm-professional
        jetbrains.webstorm
        jetbrains.phpstorm
        jetbrains.datagrip
        jetbrains.ruby-mine
        jetbrains.dataspell
        jetbrains.rider
        jetbrains.rust-rover
        jetbrains.goland
      ];
    };
  };
  config = mkIf cfg.enable {
    home.packages =
      vars.onlyLinuxOptionals (lib.lists.concatMap waylandAddvmopts cfg.packages)
      ++ (vars.onlyDarwinOptionals cfg.packages);
  };
}
