let
  sopsModules = import ./sops.nix;
in
{
  system = "x86_64-linux";
  modules = ({pkgs, impermanence, ...}: {
    imports = [
      ./hardware.nix
      impermanence.nixosModules.impermanence
      sopsModules.modules
    ];
    environment.systemPackages = [
    ];
    modules.nixos.boot.systemd.enable = true;
    modules.tui.openssh.enable = true;
    modules.tui.sops.enable = true;

    modules.nixos.tmp.enable = false;
    modules.nixos.sing-box.enable = true;
    networking.useDHCP = false;
    networking.resolvconf.enable = false;
    networking.firewall.enable = false;
    systemd.network.enable = true;
    services.resolved.enable = false;
    services.adguardhome.enable = true;
    users.mutableUsers = false;
    users.users.dev = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$0LGeRtjP5z3vKS1iDfUPU.$ZOpZQsNGtSvOVFMMtOql.6QRdT4TmTUu3rf3Lbazq76";
      extraGroups = [ "wheel" ];
    };
    users.users.root.hashedPassword = "$y$j9T$/hJgCqRxxVrqaFG/cVf1M0$9ApcSdGbs4N.H9tHpM3Ubu9LZHpeU1HYKRWsQAkDtF8";
    environment.persistence."/nix/persistent" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/sing-box"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/var/lib/private/AdGuardHome/AdGuardHome.yaml"
      ];
    };
  });
  users.dev = {
    username = "dev";
    home-modules = ({ pkgs, ...}: {
      imports = [
        sopsModules.home-modules
      ];
      home.packages = with pkgs; [
      ];
      home-modules.direnv.enable = true;
      home-modules.direnv.enableBashIntegration = true;
      home-modules.git.enable = true;
      home-modules.starship.enable = true;
      home-modules.starship.enableBashIntegration = true;
      home-modules.shell.bash.enable = true;
      home-modules.neovim.enable = true;

      programs.git.userName = "shug";
      programs.git.userEmail = "vxzyfx@gmail.com";
    });
  };
}