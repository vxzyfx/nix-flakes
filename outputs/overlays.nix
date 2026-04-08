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
  # neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (
  #   finalAttrs: previousAttrs: {
  #     version = "0.12.0";
  #     src = final.fetchFromGitHub {
  #       owner = "neovim";
  #       repo = "neovim";
  #       rev = "61f166ec409b7621fcc42e4da40d6ccb19973749";
  #       hash = "sha256-JLAIrpQTp8u6blb5iZrAx36fNe65LT+JOUvxiLxlN+8=";
  #     };
  #   }
  # );
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
  opencode = prev.opencode.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.4.0";
      patches = [ ];
      src = final.fetchFromGitHub {
        owner = "anomalyco";
        repo = "opencode";
        tag = "v${finalAttrs.version}";
        hash = "sha256-u3OeU+3Y/O6KEeDiOl+pswBZ7++kMqwoK+ams03qWE4=";
      };
      node_modules = previousAttrs.node_modules.overrideAttrs {
        outputHash = "sha256-atufNVv1pxdcz9TGhlZsQSwZ8E8dxJ7syPA/FD/cZWI=";
      };
    }
  );
}
