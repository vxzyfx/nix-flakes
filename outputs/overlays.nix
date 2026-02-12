final: prev:
let
  callPackage = pname: final.callPackage ./packages/${pname}.nix { };
  packages = [
    "macism"
    "sing-box"
    "kulala-ls"
    "kotlinls"
    "vscode-solidity-server"
  ];
  attrs = builtins.listToAttrs (
    builtins.map (v: {
      name = v;
      value = callPackage v;
    }) packages
  );
in
attrs
// {
  neovim-unwrapped = (prev.neovim-unwrapped.override { lua = final.luajit; }).overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.12.0";
      src = final.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "903335a6d50b020b36d1c4d5e9da362c31439d6e";
        hash = "sha256-AA3Pvn0k9lasHZzfW+raPgfWbR/wRLvVsNOISRoQmOU=";
      };
    }
  );
  opencode = prev.opencode.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.1.36";
      patches = [ ];
      src = final.fetchFromGitHub {
        owner = "anomalyco";
        repo = "opencode";
        tag = "v${finalAttrs.version}";
        hash = "sha256-ovFGFI2dSZLKSeuanRZg9cNvMCxYnS3UbtaCKls5BYQ=";
      };
      node_modules = previousAttrs.node_modules.overrideAttrs {
        outputHash = "sha256-mSJ1CvuJpi8ygJF+xHrDd7/ZQd2wkmOj7GZLfZZwMs4=";
      };
    }
  );
}
