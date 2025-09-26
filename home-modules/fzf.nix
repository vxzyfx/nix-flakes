{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.home-modules.fzf;
in
{
  options.home-modules.fzf = {
    enable = mkEnableOption "启用fzf";
  };
  config = mkIf cfg.enable {
    home-modules.bat.enable = true;
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      fileWidgetOptions = [
        "--walker-skip .git,node_modules,target"
        "--preview 'bat -n --color=always {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
      ];
      changeDirWidgetOptions = [
        "--walker-skip .git,node_modules,target"
        "--preview 'tree -C {}'"
      ];
    };
  };
}
