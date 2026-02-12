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
  packages =
    with pkgs;
    [
      clang-tools
      cmake
      gnumake
      codespell
      conan
      cppcheck
      doxygen
      gtest
      lcov
      vcpkg
      vcpkg-tool
    ]
    ++ (if stdenv.hostPlatform.system == "aarch64-darwin" then [ ] else [ gdb ]);
  shellHook = shell;
}
