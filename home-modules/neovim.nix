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
in
{
  options.home-modules.neovim = {
    enable = mkEnableOption "neovim软件";
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      extraPackages =
        with pkgs;
        [
          fd
          gcc
          git
          nil
          gopls
          vtsls
          lazygit
          ripgrep
          cmake-lint
          neocmakelsp
          basedpyright
          vscode-js-debug
          nixfmt-rfc-style
          lua-language-server
          vue-language-server
          yaml-language-server
          astro-language-server
          tailwindcss-language-server
          nodePackages.vscode-json-languageserver
        ]
        ++ vars.onlyDarwinOptionals [ pkgs.macism ];
      extraLuaConfig = ''
        vim.g.vx_codelldb = "${vx_codelldb}"
        vim.g.vx_liblldb = "${vx_liblldb}"
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
              enabled = function()
                local success, Vxvim = pcall(require, "vxvim.util")
                if not success then
                  return false
                end
                if Vxvim.is_win() then
                  return false
                end
                local ssh_connection = os.getenv("SSH_CONNECTION") -- 使用ssh时禁用
                return not ssh_connection
              end,
              config = function()
                local success, Vxvim = pcall(require, "vxvim.util")
                if not success then
                  return
                end
                local default_im_select = "com.apple.keylayout.ABC"
                local default_command = "macism"
                if Vxvim.is_linux() then
                  default_im_select = "keyboard-us"
                  default_command = "fcitx5-remote"
                end
                require("im_select").setup({
                  default_im_select = default_im_select,
                  default_command = default_command,
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
