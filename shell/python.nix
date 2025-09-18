{ pkgs, ... }:
let
  python = pkgs.python3;
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
  packages = [
    python.pkgs.venvShellHook
    python.pkgs.pip
  ];
  shellHook = shell;
}
