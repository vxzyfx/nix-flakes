{
  modules = ({ sops-nix, config, vars, ... }: {
    imports = [ sops-nix.nixosModules.sops ];
    sops.defaultSopsFile = ../../secrets + "/${vars.hostname}.yaml";
    sops.age.keyFile = "/nix/persistent/var/lib/sops-nix/keys.txt";
    # sops.age.generateKey = true;
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.secrets.sing-box = {
      mode = "0444";
      path = "/etc/sing-box/config.json";
    };
    sops.secrets.network0 = {
      mode = "0444";
      path = "/etc/systemd/network/10-eth0.network";
    };
    sops.secrets.network1 = {
      mode = "0444";
      path = "/etc/systemd/network/11-eth1.network";
    };
    sops.secrets.network2 = {
      mode = "0444";
      path = "/etc/systemd/network/12-eth2.network";
    };
    sops.secrets.network3 = {
      mode = "0444";
      path = "/etc/systemd/network/13-eth3.network";
    };
    sops.secrets.network4 = {
      mode = "0444";
      path = "/etc/systemd/network/14-eth4.network";
    };
    sops.secrets.network5 = {
      mode = "0444";
      path = "/etc/systemd/network/14-eth5.network";
    };
    sops.secrets.netdev0 = {
      mode = "0444";
      path = "/etc/systemd/network/10-dev0.netdev";
    };
    sops.secrets.netdev1 = {
      mode = "0444";
      path = "/etc/systemd/network/10-dev1.netdev";
    };
    sops.secrets.resolv = {
      mode = "0444";
      path = "/etc/resolv.conf";
    };
    sops.secrets.traefik_env = {
      mode = "0444";
    };
    sops.secrets.traefik_yaml = {
      mode = "0444";
      path = "/etc/traefik/config.yaml";
    };
  });
  home-modules = ({ sops-nix, config, vars, ... }: {
    imports = [ sops-nix.homeManagerModules.sops ];
    sops.defaultSopsFile = ../../secrets + "/${vars.hostname}.yaml";
    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    sops.secrets."ssh/config" = {
      path = "${config.home.homeDirectory}/.ssh/config";
    };
    sops.secrets."ssh/key1" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
    sops.secrets."ssh/pub1" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  });
}

