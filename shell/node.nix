{ pkgs, ... }: pkgs.mkShell {
  packages = with pkgs; [ node2nix nodejs nodePackages.pnpm yarn ];
  shellHook = "exec zsh";
}
