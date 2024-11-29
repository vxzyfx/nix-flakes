{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.k8s;
in
{
  options.home-modules.k8s = {
    kubectl.enable = mkEnableOption "kubectl软件";
    kubectl.package = mkOption {
      type = types.package;
      description = "安装的kubectl软件包";
      default = pkgs.kubectl;
    };
    kubectl.enableBashIntegration = mkEnableOption "集成bash";
    kubectl.enableZshIntegration = mkEnableOption "集成zsh";
    helm.enable = mkEnableOption "helm软件";
    helm.package = mkOption {
      type = types.package;
      description = "安装的helm软件包";
      default = pkgs.kubernetes-helm;
    };
    helm.enableBashIntegration = mkEnableOption "集成bash";
    helm.enableZshIntegration = mkEnableOption "集成zsh";
  };
  config = mkMerge [
    (mkIf cfg.kubectl.enable {
      home.packages = [ cfg.kubectl.package ];
      home-modules.k8s.helm.enable = mkDefault true;
    })
    (mkIf (cfg.kubectl.enable && cfg.kubectl.enableBashIntegration) {
      programs.bash.initExtra = lib.mkAfter ''
        source <(kubectl completion bash)
      '';
    })
    (mkIf (cfg.kubectl.enable && cfg.kubectl.enableZshIntegration) {
      programs.zsh.initExtra = lib.mkAfter ''
        source <(kubectl completion zsh)
      '';
    })
    (mkIf cfg.helm.enable {
      home.packages = [ cfg.helm.package ];
    })
    (mkIf (cfg.helm.enable && cfg.helm.enableBashIntegration) {
      programs.bash.initExtra = lib.mkAfter ''
        source <(helm completion bash)
      '';
    })
    (mkIf (cfg.helm.enable && cfg.helm.enableZshIntegration) {
      programs.zsh.initExtra = lib.mkAfter ''
        source <(helm completion zsh)
      '';
    })
  ];
}
