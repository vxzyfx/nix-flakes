let
  sopsModules = import ./sops.nix;
in
{
  system = "x86_64-linux";
  modules = (
    { pkgs, config, ... }:
    {
      imports = [
        ./hardware.nix
        sopsModules.modules
      ];
      modules.nixos.nspawn.proxy = {
        enable = true;
        networkConfig = {
          Bridge = [ "br0" ];
        };
      };
      modules.nixos.nspawn.dev = {
        networkConfig = {
          Bridge = [ "br0" ];
        };
      };
      modules.nixos.boot.systemd.enable = true;
      modules.nixos.virt.enable = true;
      modules.tui.sops.enable = true;
      modules.tui.openssh.enable = true;
      modules.tui.openssh.enableRootKey = true;
      networking.firewall.enable = false;

      networking.useDHCP = false;
      networking.resolvconf.enable = false;
      systemd.network.enable = true;
      services.resolved.enable = false;
      environment.systemPackages = [
        pkgs.dig
      ];
      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
      };
      modules.nixos.traefik = {
        enable = true;
        staticConfigOptions = {
          entryPoints = {
            web = {
              address = ":80";
            };
            websecure = {
              address = ":443";
            };
          };
          certificatesResolvers.myresolver.acme = {
            dnsChallenge = {
              provider = "cloudflare";
            };
            storage = "${config.modules.nixos.traefik.dataDir}/acme.json";
          };
        };
        environmentFiles = [ "/run/secrets/traefik_env" ];
        dynamicConfigFile = "/etc/traefik/config.yaml";
      };
      users.users.dev = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "kvm"
          "qemu-libvirtd"
          "libvirtd"
        ];
      };
    }
  );
  users.dev = {
    username = "dev";
    home-modules = (
      { pkgs, ... }:
      {
        imports = [
          sopsModules.home-modules
        ];
        home-modules.yazi.enable = true;
        home-modules.zellij.enable = true;
        home-modules.direnv.enable = true;
        home-modules.direnv.enableBashIntegration = true;
        home-modules.git.enable = true;
        home-modules.starship.enable = true;
        home-modules.starship.enableBashIntegration = true;
        home-modules.shell.bash.enable = true;
        home-modules.neovim.enable = true;

        programs.git.settings.user.name = "shug";
        programs.git.settings.user.email = "vxzyfx@gmail.com";
      }
    );
  };
}
