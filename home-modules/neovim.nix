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
in {
  options.home-modules.neovim = {
    enable = mkEnableOption "neovim软件";
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
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
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "plugins" },
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
    xdg.configFile."nvim/lua/plugins/lang.lua".text = ''
      local function determine_os()
        if vim.fn.has("macunix") == 1 then
          return "macOS"
        elseif vim.fn.has("win32") == 1 then
          return "Windows"
        elseif vim.fn.has("wsl") == 1 then
          return "WSL"
        else
          return "Linux"
        end
      end
      return {
        {
          "keaising/im-select.nvim",
          enabled = function()
            local ssh_connection = os.getenv("SSH_CONNECTION") -- 使用ssh时禁用
            return not ssh_connection
          end,
          config = function()
            local os = determine_os()
            local default_im_select = "com.apple.keylayout.ABC"
            if os == "Linux" then
              default_im_select = "keyboard-us"
            end
            require("im_select").setup({
              default_im_select = default_im_select,
            })
          end,
        },
      }
    '';
    xdg.configFile."nvim/lua/plugins/code.lua".text = ''
      return {
        {
          "hrsh7th/nvim-cmp",
          ---@param opts cmp.ConfigSchema
          opts = function(_, opts)
            local has_words_before = function()
              unpack = unpack or table.unpack
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
    
            local cmp = require("cmp")
    
            opts.mapping = vim.tbl_extend("force", opts.mapping, {
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
                  cmp.select_next_item()
                elseif vim.snippet.active({ direction = 1 }) then
                  vim.schedule(function()
                    vim.snippet.jump(1)
                  end)
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif vim.snippet.active({ direction = -1 }) then
                  vim.schedule(function()
                    vim.snippet.jump(-1)
                  end)
                else
                  fallback()
                end
              end, { "i", "s" }),
            })
          end,
        },
        {
          "folke/which-key.nvim",
          optional = true,
          opts = function(_, opts)
            vim.list_extend(opts.spec, {
              mode = { "n", "v" },
              { "<leader>m", group = "my"  }
            })
          end
        }
      }
    '';
    xdg.configFile."nvim/lua/plugins/langkey.lua".text = ''
      return {
        {
          'mrcjkb/rustaceanvim',
          optional = true,
          lazy = true,
          ft = "rust" ,
          keys = { { "<leader>mr", function() vim.cmd.RustLsp('runnables') end, ft = "rust", desc = "Run Target" } },
        },
        {
          "Civitasv/cmake-tools.nvim",
          optional = true,
          keys = {
            { "<leader>mr", "<cmd>CMakeRun<CR>", ft = { "c", "cpp" }, desc = "Run Target" },
            { "<leader>mb", "<cmd>CMakeBuild<CR>", ft = { "c", "cpp" }, desc = "Build Target" },
            { "<leader>ml", "<cmd>CMakeSelectLaunchTarget<CR>", ft = { "c", "cpp" }, desc = "Select Launch Target" },
            { "<leader>mt", "<cmd>CMakeSelectBuildTarget<CR>", ft = { "c", "cpp" }, desc = "Select Target" },
            { "<leader>ma", function() local args = vim.fn.input("input args");  vim.cmd("CMakeLaunchArgs " .. args); end, ft = { "c", "cpp" }, desc = "Launch Args" },
          },
        }
      }
    '';
    xdg.configFile."nvim/lazyvim.json".text = ''
      {
        "extras": [
          "lazyvim.plugins.extras.coding.mini-surround",
          "lazyvim.plugins.extras.coding.yanky",
          "lazyvim.plugins.extras.dap.core",
          "lazyvim.plugins.extras.editor.aerial",
          "lazyvim.plugins.extras.editor.dial",
          "lazyvim.plugins.extras.editor.fzf",
          "lazyvim.plugins.extras.editor.harpoon2",
          "lazyvim.plugins.extras.editor.inc-rename",
          "lazyvim.plugins.extras.editor.leap",
          "lazyvim.plugins.extras.editor.mini-move",
          "lazyvim.plugins.extras.editor.navic",
          "lazyvim.plugins.extras.formatting.black",
          "lazyvim.plugins.extras.formatting.prettier",
          "lazyvim.plugins.extras.lang.ansible",
          "lazyvim.plugins.extras.lang.clangd",
          "lazyvim.plugins.extras.lang.cmake",
          "lazyvim.plugins.extras.lang.docker",
          "lazyvim.plugins.extras.lang.git",
          "lazyvim.plugins.extras.lang.go",
          "lazyvim.plugins.extras.lang.helm",
          "lazyvim.plugins.extras.lang.json",
          "lazyvim.plugins.extras.lang.nix",
          "lazyvim.plugins.extras.lang.markdown",
          "lazyvim.plugins.extras.lang.python",
          "lazyvim.plugins.extras.lang.rust",
          "lazyvim.plugins.extras.lang.tailwind",
          "lazyvim.plugins.extras.lang.toml",
          "lazyvim.plugins.extras.lang.typescript",
          "lazyvim.plugins.extras.lang.vue",
          "lazyvim.plugins.extras.lang.yaml",
          "lazyvim.plugins.extras.linting.eslint",
          "lazyvim.plugins.extras.lsp.none-ls",
          "lazyvim.plugins.extras.test.core",
          "lazyvim.plugins.extras.ui.mini-indentscope",
          "lazyvim.plugins.extras.util.dot",
          "lazyvim.plugins.extras.util.mini-hipatterns",
          "lazyvim.plugins.extras.util.project",
          "lazyvim.plugins.extras.util.rest"
        ],
        "news": {
          "NEWS.md": "7429"
        },
        "version": 7
      }
    '';
  };
}
