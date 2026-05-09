final: prev:
let
  callPackage = pname: final.callPackage ./packages/${pname}.nix { };
  packages = [
    "macism"
    "sing-box"
    "kulala-ls"
    "kotlinls"
    "opencode"
    "vscode-solidity-server"
  ];
  attrs = builtins.listToAttrs (
    map (v: {
      name = v;
      value = callPackage v;
    }) packages
  );
in
attrs
// {
  # gdb = prev.gdb.overrideAttrs (
  #   finalAttrs: previousAttrs: {
  #     patches = previousAttrs.patches ++ [ gdb-patche ];
  #   }
  # );
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.12.2";
      src = final.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "v${finalAttrs.version}";
        hash = "sha256-V+jZiNv0SvG/GOOUPzmBkOQGrnrN3UW2BY2n9NxP2Eg=";
      };
    }
  );
  ollama = prev.ollama.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.17.7";
      src = final.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        tag = "v${finalAttrs.version}";
        hash = "sha256-cAqc38NHvUo5gphq1csTyosTcpUjFcs0dzB0wreEGjs=";
      };
    }
  );
}
