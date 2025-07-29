{ pkgs, ... }:
let
  shell =
    if pkgs.stdenv.isDarwin then
      ''
        export SHELL=${pkgs.lib.getExe pkgs.zsh}
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
        exec ${pkgs.lib.getExe pkgs.zsh}
      ''
    else
      "";
  darwinPackage = if pkgs.stdenv.hostPlatform.isDarwin then [ pkgs.cocoapods ] else [ ];
in
pkgs.mkShell {
  env = {
    FLUTTER_ROOT = pkgs.flutter;
    DART_ROOT = "${pkgs.flutter}/bin/cache/dart-sdk";
    JAVA_HOME = "${pkgs.jdk17.home}";
  };
  packages =
    with pkgs;
    [
      jdk17
      flutter
    ]
    ++ darwinPackage;
  shellHook = shell;
}
