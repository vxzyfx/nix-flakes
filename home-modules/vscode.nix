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
  rustExtensions =
    with pkgs.vscode-extensions;
    optionals cfg.extensions.rust [
      rust-lang.rust-analyzer
    ];
  webExtensions =
    with pkgs.vscode-extensions;
    optionals cfg.extensions.web [
      vue.volar
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
    ];
in
{
  options.home-modules.vscode = {
    enable = mkEnableOption "vscode软件";
    package = mkOption {
      type = types.package;
      description = "安装的vscode软件包";
      default = defalutPackage;
    };
    extensions = {
      rust = mkEnableOption "rust拓展";
      web = mkEnableOption "web拓展";
    };
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
      extensions = rustExtensions ++ webExtensions;
    };
  };
}
