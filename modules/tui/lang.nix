{
  pkgs,
  lib,
  config,
  vars,
  ...
}: 
with lib;

let
  cfg = config.modules.tui.lang;
in {
  options.modules.tui.lang = {
    enableAll = mkEnableOption "启用所有语言";
    js.enable = mkEnableOption "启用nodejs";
    js.package = mkOption {
      type = types.listOf types.package;
      description = "nodejs的安装包";
      default = with pkgs; [
        nodejs_22
      ];
    };
    rust.enable = mkEnableOption "启用rust";
    rust.package = mkOption {
      type = types.listOf types.package;
      description = "rust的安装包";
      default = with pkgs; [
        rustup
      ];
    };
    python.enable = mkEnableOption "启用python";
    python.package = mkOption {
      type = types.listOf types.package;
      description = "python的安装包";
      default = with pkgs; [
        python312
        python312Packages.pip
      ];
    };
    go.enable = mkEnableOption "启用go";
    go.package = mkOption {
      type = types.listOf types.package;
      description = "go的安装包";
      default = with pkgs; [
        go
      ];
    };
    dotnet.enable = mkEnableOption "启用dotnet";
    dotnet.package = mkOption {
      type = types.listOf types.package;
      description = "dotnet的安装包";
      default = with pkgs; [
        dotnet-sdk_8
      ];
    };
    php.enable = mkEnableOption "启用php";
    php.package = mkOption {
      type = types.listOf types.package;
      description = "php的安装包";
      default = with pkgs; [
        php83
      ];
    };
    ruby.enable = mkEnableOption "启用ruby";
    ruby.package = mkOption {
      type = types.listOf types.package;
      description = "ruby的安装包";
      default = with pkgs; [
        ruby_3_3
      ];
    };
    c.enable = mkEnableOption "启用c/c++";
    c.package = mkOption {
      type = types.listOf types.package;
      description = "c/c++的安装包";
      default = with pkgs; [
        gcc14
      ];
    };
  };
  config = mkMerge [
  (mkIf cfg.enableAll {
    modules.tui.lang.js.enable = mkDefault true;
    modules.tui.lang.rust.enable = mkDefault true;
    modules.tui.lang.python.enable = mkDefault true;
    modules.tui.lang.go.enable = mkDefault true;
    modules.tui.lang.dotnet.enable = mkDefault true;
    modules.tui.lang.php.enable = mkDefault true;
    modules.tui.lang.ruby.enable = mkDefault true;
    modules.tui.lang.c.enable = mkDefault true;
  })
  (mkIf cfg.js.enable {
    environment.systemPackages = cfg.js.package;
  })
  (mkIf cfg.rust.enable {
    environment.systemPackages = cfg.rust.package;
  })
  (mkIf cfg.python.enable {
    environment.systemPackages = cfg.python.package;
  })
  (mkIf cfg.go.enable {
    environment.systemPackages = cfg.go.package;
  })
  (mkIf cfg.dotnet.enable {
    environment.systemPackages = cfg.dotnet.package;
  })
  (mkIf cfg.php.enable {
    environment.systemPackages = cfg.php.package;
  })
  (mkIf cfg.ruby.enable {
    environment.systemPackages = cfg.ruby.package;
  })
  (mkIf cfg.c.enable {
    environment.systemPackages = cfg.c.package;
  })
  ];
}
