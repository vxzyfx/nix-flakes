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
in {
  options.home-modules.vscode = {
    enable = mkEnableOption "vscode软件";
    package = mkOption {
      type = types.package;
      description = "安装的vscode软件包";
      default = pkgs.vscode;
    };
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
    };
  };
}
