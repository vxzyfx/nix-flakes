{
  pkgs,
  vars,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.modules.tui.homebrew;
in
{
  options.modules.tui.homebrew = {
    enable = mkEnableOption "nix管理homebrew";
    masApps = mkOption {
      type = types.attrsOf types.ints.positive;
      default = { };
      description = "通过masApps按照App Store的软件";
    };
    autoUpdate = mkOption {
      type = types.bool;
      default = true;
      description = "homebrew自动更新";
    };
    upgrade = mkOption {
      type = types.bool;
      default = true;
      description = "更新formulae and Mac App Store apps";
    };
    cleanup = mkOption {
      type = types.str;
      default = "zap";
      description = "homebrew清理方式, zap会卸载nix没有管理的软件";
    };
    brews = mkOption {
      type = types.listOf types.singleLineStr;
      default = [ ];
      description = "homebrew的brew软件";
    };
    casks = mkOption {
      type = types.listOf types.singleLineStr;
      default = [ ];
      description = "homebrew安装casks";
    };

  };
  config = vars.onlyDarwinOptionalAttrs (
    mkIf cfg.enable {
      homebrew.enable = mkDefault true;
      homebrew.masApps = mkDefault cfg.masApps;
      homebrew.onActivation.autoUpdate = mkDefault cfg.autoUpdate;
      homebrew.onActivation.upgrade = mkDefault cfg.upgrade;
      homebrew.onActivation.cleanup = mkDefault cfg.cleanup;
      homebrew.taps = mkDefault [ "homebrew/services" ];
      homebrew.brews = cfg.brews ++ [ "mas" ];
      homebrew.casks = mkDefault cfg.casks;
    }
  );
}
