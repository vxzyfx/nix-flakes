{ pkgs, vars, ... }:
let
  shell =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "export SHELL=${pkgs.lib.getExe pkgs.zsh}; exec ${pkgs.lib.getExe pkgs.zsh}"
    else
      "";
in
pkgs.mkShell {
  packages = with pkgs; [
    rustToolchain
    openssl
    pkg-config
    cargo-deny
    cargo-edit
    cargo-watch
    rust-analyzer
  ];

  env = {
    # Required by rust-analyzer
    RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
  };
  shellHook = shell;
}
