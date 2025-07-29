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
  targets = [
    "aarch64-apple-darwin"
    "aarch64-unknown-linux-ohos"
    "aarch64-unknown-linux-gnu"
    "aarch64-unknown-linux-musl"
    "x86_64-unknown-linux-musl"
    "x86_64-unknown-linux-gnu"
  ];
  combines = builtins.map (target: pkgs.fenix.targets.${target}.stable.rust-std) targets;
  toolchain = pkgs.fenix.combine (
    with pkgs.fenix;
    [
      stable.toolchain
    ]
    ++ combines
  );
in
pkgs.mkShell {
  packages = with pkgs; [
    toolchain
    openssl
    pkg-config
    cargo-deny
    cargo-edit
    cargo-watch
    protobuf
    buf
    cmake
  ];

  env = {
    # Required by rust-analyzer
    RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
  };
  shellHook = shell;
}
