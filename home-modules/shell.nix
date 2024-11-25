{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.shell;
  shellAliases = {
    ls = "ls --color";
  };
in {
  options.home-modules.shell.shellAliases = mkOption {
      type = with types; attrsOf str;
      default = {};
      example = literalExpression ''
        {
          g = "git";
          "..." = "cd ../..";
        }
      '';
      description = "shell别名";
  };
  options.home-modules.shell.bash = {
    enable = mkEnableOption "启用bash";
    enableCompletion = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "bash自动补全";
    };
  };
  options.home-modules.shell.zsh = {
    enable = mkEnableOption "启用zsh";
    enableCompletion = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "zsh自动补全";
    };
  };
  config = mkMerge [
  {
    home.shellAliases = shellAliases // cfg.shellAliases;
  }
  (mkIf cfg.bash.enable {
    programs.bash = {
      enable = mkDefault cfg.bash.enable;
      enableCompletion = mkDefault cfg.bash.enableCompletion;
    };
  })
  (mkIf cfg.zsh.enable {
    programs.zsh = {
      enable = mkDefault cfg.zsh.enable;
      enableCompletion = mkDefault cfg.zsh.enableCompletion;
      initExtra = mkBefore ''
        bindkey  "^[[H"   beginning-of-line
        bindkey  "^[[F"   end-of-line
        bindkey  "^[[3~"  delete-char
      '';
    };
  })
  ];
}
