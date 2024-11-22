{pkgs, vars, lib, options, config, ...}:

with lib;
let
  cfg = config.modules.gui.input;
in
{
  options.modules.gui.input = {
    fcitx5.enable = mkEnableOption "fcitx5输入法";
  };
  config = vars.onlyLinuxOptionalAttrs (mkIf cfg.fcitx5.enable {
    i18n.inputMethod.type = "fcitx5";
    i18n.inputMethod.enable = true;
    i18n.inputMethod.fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        fcitx5-tokyonight
      ];
      settings = {
        addons = {
          classicui.globalSection.Font = "Microsoft YaHei 12";
          classicui.globalSection.Theme = "Tokyonight-Storm";
          classicui.globalSection.DarkTheme = "Tokyonight-Storm";
          pinyin.globalSection = {
            PageSize = 9;
            CloudPinyinEnabled = "True";
            CloudPinyinIndex = 2;
          };
          cloudpinyin.globalSection = {
            Backend = "Baidu";
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
          GroupOrder."0" = "Default";
        };
      };
    };
  });
}
