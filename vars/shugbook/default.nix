let
  sopsModules = import ./sops.nix;
in
{
  system = "x86_64-linux";
  modules = (
    { pkgs, ... }:
    {
      imports = [
        ./hardware.nix
        sopsModules.modules
      ];
      modules.gui.font.enable = true;
      modules.nixos.boot.systemd.enable = true;
      modules.nixos.virt.enable = true;
      modules.nixos.virt.enableVirtManager = true;
      modules.nixos.logid.enable = true;
      modules.nixos.desktop.enable = true;
      modules.tui.sops.enable = true;
      modules.tui.openssh.enable = true;
      modules.tui.lang.enableAll = true;

      networking.useDHCP = false;
      networking.resolvconf.enable = false;
      networking.wireless.iwd.enable = true;
      boot.blacklistedKernelModules = [ "nouveau" ];
      systemd.network.enable = true;
      services.resolved.enable = false;
      users.users.shug = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "audio"
          "video"
          "lp"
          "kvm"
          "uucp"
          "input"
          "seat"
          "dialout"
          "qemu-libvirtd"
          "libvirtd"
        ];
      };
    }
  );
  users.shug = {
    username = "shug";
    home-modules = (
      { pkgs, ... }:
      {
        imports = [
          sopsModules.home-modules
        ];
        home.packages = with pkgs; [
          remmina
        ];
        home-modules.nnn.enable = true;
        home-modules.direnv.enable = true;
        home-modules.direnv.enableBashIntegration = true;
        home-modules.git.enable = true;
        home-modules.jetbrains.enable = true;
        home-modules.kitty.enable = true;
        home-modules.fzf.enable = true;
        home-modules.bat.enable = true;
        home-modules.starship.enable = true;
        home-modules.starship.enableBashIntegration = true;
        home-modules.shell.bash.enable = true;
        home-modules.niri = {
          enable = true;
          bg = ./bg.jpg;
          systemd.enable = true;
          outputs."eDP-1" = {
            mode = "2160x1440@60";
            scale = 1.5;
          };
          outputs."DP-1" = {
            mode = "3840x2160@60";
            scale = 2.0;
            position = {
              x = 1440;
            };
          };
        };
        home-modules.launcher.fuzzel.enable = true;
        home-modules.waybar.enable = true;
        home-modules.mako.enable = true;
        home-modules.neovim.enable = true;
        home-modules.vscode = {
          enable = true;
          extensions = {
            remote = true;
            rust = true;
            web = true;
          };
        };

        programs.git.settings.user.name = "shug";
        programs.git.settings.user.email = "vxzyfx@gmail.com";
      }
    );
  };
}
