{
  modules = ({ sops-nix, config, vars, ... }: {
    imports = [ sops-nix.nixosModules.sops ];
    sops.defaultSopsFile = ../../secrets + "/${vars.hostname}.yaml";
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = true;
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.secrets.network = {
      mode = "0444";
      path = "/etc/systemd/network/eth0.network";
    };
    sops.secrets.resolv = {
      mode = "0444";
      path = "/etc/resolv.conf";
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
    sops.secrets."ssh/key2" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_mac";
    };
    sops.secrets."ssh/pub2" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_mac.pub";
    };
    sops.secrets."ssh/key3" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_read";
    };
    sops.secrets."ssh/pub3" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_read.pub";
    };
  });
}

