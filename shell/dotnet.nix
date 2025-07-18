{ pkgs, ... }:
let
  shell =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "export SHELL=${pkgs.lib.getExe pkgs.zsh}; exec ${pkgs.lib.getExe pkgs.zsh}"
    else
      "";
in
pkgs.mkShell {
  packages = with pkgs; [
    dotnet-sdk_9
  ];
  shellHook = shell;
}
