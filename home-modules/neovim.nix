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
      extraPackages =
        with pkgs;
        [
          fd
          gcc
          gdb
          git
          nil
          zls
          deno
          solc
          black
          cmake
          delve
          gopls
          isort
          shfmt
          vtsls
          stylua
          gnumake
          gofumpt
          gotools
          helm-ls
          lazygit
          lldb_20
          ripgrep
          prettier
          nodejs_22
          roslyn-ls
          csharpier
          cmake-lint
          netcoredbg
          shellcheck
          ghostscript
          imagemagick
          mermaid-cli
          neocmakelsp
          tree-sitter
          basedpyright
          golangci-lint
          rust-analyzer
          sourcekit-lsp
          vscode-js-debug
          nixfmt-rfc-style
          markdownlint-cli2
          lua-language-server
          vue-language-server
          bash-language-server
          yaml-language-server
          astro-language-server
          vscode-json-languageserver
          tailwindcss-language-server
          llvmPackages_20.clang-tools
          dockerfile-language-server-nodejs
        ]
        ++ vars.onlyDarwinOptionals [ pkgs.macism ];
      extraLuaConfig = ''
        vim.g.vx_codelldb = "${vx_codelldb}"
        vim.g.vx_liblldb = "${vx_liblldb}"
        vim.g.vx_tsdk = "${vx_tsdk}"
        vim.g.vx_ts_vue_location = "${vx_ts_vue_location}"
        vim.g.vx_cpptools = "${vx_cpptools}"
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not (vim.uv or vim.loop).fs_stat(lazypath) then
          local lazyrepo = "https://github.com/folke/lazy.nvim.git"
          local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
          if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
              { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
              { out, "WarningMsg" },
              { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
          end
        end
        vim.opt.rtp:prepend(lazypath)

        vim.g.mapleader = " "
        vim.g.maplocalleader = "\\"

        require("lazy").setup({
          spec = {
            { "vxzyfx/vxvim", import = "vxvim.plugins" },
            {
              "keaising/im-select.nvim",
              cond = function()
                return vim.env.SSH_TTY == nil
              end,
              config = function()
                require("im_select").setup({
                  default_im_select = "${default_im_select}",
                  default_command = "${default_command}",
                })
              end,
            },
          },
          defaults = {
            lazy = false,
            version = false,
          },
          install = { colorscheme = { "catppuccin" } },
          checker = {
            enabled = true,
            notify = false,
          },
          performance = {
            rtp = {
              disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })
      '';
    };
  };
}
