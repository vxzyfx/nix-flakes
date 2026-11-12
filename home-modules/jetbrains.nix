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
        intellij-idea
        clion
        pycharm
        webstorm
        phpstorm
        datagrip
        ruby-mine
        dataspell
        rider
        rust-rover
        goland
      ];
    };
  };
  config = mkIf cfg.enable {
    home.packages =
      vars.onlyLinuxOptionals (lib.lists.concatMap waylandAddvmopts cfg.packages)
      ++ (vars.onlyDarwinOptionals cfg.packages);
  };
}
