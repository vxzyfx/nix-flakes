{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  coreutils,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "sing-box";
  version = "1.12.0-beta.33";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-box";
    tag = "v1.12.0-beta.33";
    hash = "sha256-+5VmVfcO2mTA0BQuPZRQZTgt7ujYpwynB2gO6OB0ilI=";
  };

  vendorHash = "sha256-BNRAAfXUFV0CwRXvVu0Ix1yX9ISALsdrfJ0neM+ML9M=";

  tags = [
    "with_quic"
    "with_dhcp"
    "with_wireguard"
    "with_utls"
    "with_acme"
    "with_clash_api"
    "with_gvisor"
  ];

  subPackages = [
    "cmd/sing-box"
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X=github.com/sagernet/sing-box/constant.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion release/completions/sing-box.{bash,fish,zsh}

    substituteInPlace release/config/sing-box{,@}.service \
      --replace-fail "/usr/bin/sing-box" "$out/bin/sing-box" \
      --replace-fail "/bin/kill" "${coreutils}/bin/kill"
    install -Dm444 -t "$out/lib/systemd/system/" release/config/sing-box{,@}.service
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) sing-box;
    };
  };

  meta = {
    homepage = "https://sing-box.sagernet.org";
    description = "Universal proxy platform";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nickcao
      prince213
    ];
    mainProgram = "sing-box";
  };
})
