{ pkgs, ... }:
let
  shell =
    if pkgs.stdenv.isDarwin then
      ''
        export SHELL=${pkgs.lib.getExe pkgs.zsh}
        exec ${pkgs.lib.getExe pkgs.zsh}
      ''
    else
      "";
in
pkgs.mkShell {
  packages = with pkgs; [
    php
    phpPackages.composer
  ];
  shellHook = shell;
}
