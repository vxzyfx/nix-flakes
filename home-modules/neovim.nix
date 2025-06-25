{
  pkgs,
  lib,
  config,
  vars,
  mylib,
  ...
}:
with lib;

let
  cfg = config.home-modules.neovim;
  packages = mylib.packages { inherit pkgs lib; };
in
{
  options.home-modules.neovim = {
    enable = mkEnableOption "neovim软件";
  };
  config = mkIf cfg.enable {
    home.packages = vars.onlyDarwinOptionals [ packages.im-select ];
    programs.neovim = {
      enable = true;
      viAlias = true;
      extraPackages =
        with pkgs;
        [
          fd
          gcc
          git
          lazygit
          ripgrep
          cmake-lint
          vscode-js-debug
          nixfmt-rfc-style
          lua-language-server
          vue-language-server
        ]
        ++ vars.onlyDarwinOptionals [ packages.im-select ];
      extraLuaConfig = ''
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

        require("lazy").setup({
          spec = {
            { "vxzyfx/vxvim", import = "vxvim.plugins" },
            { "vxzyfx/vxvim", priority = 10000, lazy = false, opts = {}, cond = true, version = "*" },
            {
              "keaising/im-select.nvim",
              enabled = function()
                local Vxvim = require("vxvim.util")
                if Vxvim.is_win() then
                  return false
                end
                local ssh_connection = os.getenv("SSH_CONNECTION") -- 使用ssh时禁用
                return not ssh_connection
              end,
              config = function()
                local Vxvim = require("vxvim.util")
                local default_im_select = "com.apple.keylayout.ABC"
                local default_command = "im-select"
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
          install = { colorscheme = { "tokyonight" } },
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
