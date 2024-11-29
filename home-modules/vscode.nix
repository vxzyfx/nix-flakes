{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.vscode;
  defalutPackage =
    if vars.isLinux then
      (pkgs.vscode.override {
        commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --gtk-version=4";
      })
    else
      pkgs.vscode;
in
{
  options.home-modules.vscode = {
    enable = mkEnableOption "vscode软件";
    package = mkOption {
      type = types.package;
      description = "安装的vscode软件包";
      default = defalutPackage;
    };
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
    };
  };
}
