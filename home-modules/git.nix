{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.git;
in
{
  options.home-modules.git = {
    enable = mkEnableOption "启用git";
    username = mkOption {
      type = types.str;
      description = "git username";
    };
    email = mkOption {
      type = types.str;
      description = "git email";
    };
    sign = {
      enable = mkEnableOption "git签名";
      key = mkOption {
        type = types.str;
        description = "gpg sign keyid";
        default = "~/.ssh/id_ed25519";
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.git = {
        enable = true;
        settings = {
          init = {
            defaultBranch = "main";
          };
          user = {
            name = cfg.username;
            email = cfg.email;
          };
        };
        lfs.enable = true;
      };
      home.shellAliases = {
        lg = "lazygit";
      };
      programs.lazygit = {
        enable = true;
        settings = { };
      };
    }
    (mkIf cfg.sign.enable {
      programs.git.signing.format = "ssh";
      programs.git.signing.key = cfg.sign.key;
      programs.git.settings.tag.gpgSign = true;
      programs.git.settings.commit.gpgsign = true;
    })
  ]);
}
