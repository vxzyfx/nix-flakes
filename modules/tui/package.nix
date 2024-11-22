{
  pkgs,
  lib,
  config,
  ...
}: 
with lib;

let
  cfg = config.modules.tui.package;
in {
  options.modules.tui.package = {
    enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "安装通用软件包";
    };
    packages = mkOption {
      type = types.listOf types.package;
      description = "通用软件包";
      default = with pkgs;[
        git
        wget
        vim
        curlHTTP3
        neofetch
        tree
        file
        rar
        jq
        fzf
      ];
    };
    packagesExtra = mkOption {
      type = types.listOf types.package;
      description = "额外的软件包";
      default = [];
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = cfg.packages ++ cfg.packagesExtra;
  };
}
