{
  pkgs,
  lib,
  config,
  ...
}: 
with lib;

let
  cfg = config.modules.gui.font;
in {
  options.modules.gui.font = {
    enable = mkEnableOption "编程字体";
    yahei.enable = mkEnableOption "添加微软雅黑字体";
    extFonts = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "额外的字体";
    };
  };
  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (mkIf cfg.yahei.enable vistafonts-chs)
      font-awesome
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ] ++ cfg.extFonts;
  };
}
