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
    node2nix
    nodejs
    nodePackages.pnpm
    yarn
  ];
  shellHook = shell;
}
