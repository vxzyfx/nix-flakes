{
  pkgs,
  ...
}:
let
  jdk = pkgs.jdk23;
  localKotlin = pkgs.kotlin.override { jre = jdk; };
  localMaven = pkgs.maven.override { jdk_headless = jdk; };
  localGradle = pkgs.gradle.override { java = jdk; };
  localLombok = pkgs.lombok.override { inherit jdk; };
  loadLombok = "-javaagent:${localLombok}/share/java/lombok.jar";
  prev = "\${JAVA_TOOL_OPTIONS:+ $JAVA_TOOL_OPTIONS}";
  shell =
    if pkgs.stdenv.isDarwin then
      ''
        export JAVA_TOOL_OPTIONS="${loadLombok}${prev}"
        export SHELL=${pkgs.lib.getExe pkgs.zsh}
        exec ${pkgs.lib.getExe pkgs.zsh}
      ''
    else
      ''export JAVA_TOOL_OPTIONS="${loadLombok}${prev}'';
in
pkgs.mkShell {
  packages = with pkgs; [
    localKotlin
    localGradle
    localMaven
    gcc
    jdk
    ncurses
    patchelf
    zlib
  ];
  shellHook = shell;
}
