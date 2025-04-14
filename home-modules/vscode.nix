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
  rustExtensions = optionals cfg.extensions.rust (
    with pkgs.vscode-extensions;
    [
      rust-lang.rust-analyzer
    ]
  );
  webExtensions = optionals cfg.extensions.web (
    with pkgs.vscode-extensions;
    [
      vue.volar
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
    ]
  );
  commonExtensions = with pkgs.vscode-extensions; [
    fill-labs.dependi
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
      profiles.default.extensions = commonExtensions ++ rustExtensions ++ webExtensions;
    };
  };
}
