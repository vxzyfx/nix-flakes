{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
with lib;

let
  cfg = config.home-modules.neovim;
  vx_codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
  vx_liblldb =
    if vars.isLinux then "${pkgs.lldb_20}/lib/liblldb.so" else "${pkgs.lldb_20}/lib/liblldb.dylib";
  vx_ts_vue_location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
  vx_tsdk = "${pkgs.vtsls}/lib/vtsls-language-server/node_modules/typescript/lib";
  vx_cpptools = "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7";
  vx_lombok = "${pkgs.lombok}/share/java/lombok.jar";
  vx_java_debug = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar";
  vx_java_test = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar";
  default_im_select = if vars.isLinux then "keyboard-us" else "com.apple.keylayout.ABC";
  default_command = if vars.isLinux then "fcitx5-remote" else "macism";
in
{
  options.home-modules.neovim = {
    enable = mkEnableOption "neovim软件";
  };
  config = mkIf cfg.enable {
    home.shellAliases = {
      n = "nvim";
    };
    programs.neovim = {
      enable = true;
      viAlias = true;
      initLua = ''
        vim.pack.add({{ src = "https://github.com/vxzyfx/vxvim.nvim.git" }})
        require("vxvim").setup({})
      '';
      extraPackages =
        with pkgs;
        [
          fd
          gcc
          gdb
          git
          zls
          deno
          nixd
          solc
          black
          cmake
          delve
          gopls
          isort
          shfmt
          vtsls
          ktlint
          nixfmt
          stylua
          nodejs
          gnumake
          gofumpt
          gotools
          grpcurl
          helm-ls
          lazygit
          lldb_20
          python3
          ripgrep
          ast-grep
          kotlinls
          phpactor
          prettier
          websocat
          roslyn-ls
          csharpier
          cmake-lint
          kulala-fmt
          netcoredbg
          shellcheck
          ghostscript
          imagemagick
          mermaid-cli
          neocmakelsp
          tree-sitter26
          basedpyright
          golangci-lint
          probe-rs-tools
          vscode-js-debug
          markdownlint-cli2
          jdt-language-server
          lua-language-server
          vue-language-server
          bash-language-server
          yaml-language-server
          astro-language-server
          dockerfile-language-server
          vscode-json-languageserver
          tailwindcss-language-server
          llvmPackages_20.clang-tools
          lua51Packages.lua
          lua51Packages.luarocks
          php83Packages.php-cs-fixer
          php83Packages.php-codesniffer
        ]
        ++ vars.onlyDarwinOptionals [ pkgs.macism ];
    };
  };
}
