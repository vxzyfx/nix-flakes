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
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
    home.shellAliases = {
      lg = "lazygit";
    };
    programs.lazygit = {
      enable = true;
      settings = { };
    };
  };
}
