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
      services.adguardhome.enable = true;
      environment.systemPackages = [
        pkgs.dig
      ];
      modules.nixos.sing-box.enable = true;
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
        home-modules.direnv.enable = true;
        home-modules.direnv.enableBashIntegration = true;
        home-modules.git.enable = true;
        home-modules.starship.enable = true;
        home-modules.starship.enableBashIntegration = true;
        home-modules.shell.bash.enable = true;
        home-modules.neovim.enable = true;

        programs.git.userName = "shug";
        programs.git.userEmail = "vxzyfx@gmail.com";
      }
    );
  };
}
