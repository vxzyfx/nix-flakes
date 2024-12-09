{
  system = "aarch64-darwin";
  modules = (
    { pkgs, ... }:
    {
      modules.gui.aerospace.enable = true;
      modules.gui.font.enable = true;
      modules.tui.homebrew = {
        enable = true;
        masApps = {
          Xcode = 497799835;
          WeChat = 836500024;
          Amphetamine = 937984704; # 管理熄屏时间
        };
        brews = [
          "openjdk@17"
          "openjdk@21"
        ];
        casks = [
          "arduino-ide"
          "wireshark"
          "google-chrome"
          "firefox"
        ];
      };
      modules.tui.sops.enable = true;
      modules.tui.openssh.enable = true;
      modules.tui.lang.enableAll = true;
    }
  );
  users.shug = {
    username = "shug";
    home-modules = (
      {
        sops-nix,
        config,
        vars,
        ...
      }:
      {
        imports = [ sops-nix.homeManagerModules.sops ];
        sops.defaultSopsFile = ../secrets + "/${vars.hostname}.yaml";
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
        home-modules.direnv.enable = true;
        home-modules.direnv.enableZshIntegration = true;
        home-modules.git.enable = true;
        home-modules.jetbrains.enable = true;
        home-modules.neovim.enable = true;
        home-modules.kitty.enable = true;
        home-modules.starship.enable = true;
        home-modules.starship.enableZshIntegration = true;
        home-modules.vscode.enable = true;
        home-modules.shell.zsh.enable = true;
        home-modules.shell.sessionVariables = {
          LANG = "en_US.UTF-8";
          GRADLE_USER_HOME = "${config.home.homeDirectory}/Code/lib/gradle";
          CARGO_HOME = "${config.home.homeDirectory}/Code/lib/cargo";
        };
        home-modules.k8s.kubectl.enable = true;
        home-modules.k8s.kubectl.enableZshIntegration = true;
        home-modules.k8s.helm.enable = true;
        home-modules.k8s.helm.enableZshIntegration = true;

        programs.git.userName = "shug";
        programs.git.userEmail = "vxzyfx@gmail.com";
      }
    );
  };
}
