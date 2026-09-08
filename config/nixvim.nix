{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    nixpkgs.pkgs = pkgs;

    colorscheme = "islands-dark";
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "islands-dark-nvim";
        version = "2026-08-05";
        src = pkgs.fetchFromGitHub {
          owner = "karthiknatarajan";
          repo = "islands-dark.nvim";
          rev = "53b3dece96f7e29272a54f8acdfccf9f4a9ddbd7";
          hash = "sha256-uXzI3SxbhSj1v0PmitfVrapcZbP6ajLSxow3ZeQPUsY=";
        };
      })
    ];

    plugins.web-devicons.enable = true;
    plugins.treesitter.enable = true;

    plugins.telescope.enable = true;

    plugins.lspconfig.enable = true;
    lsp.servers = {
      "*".config.capabilities.__raw = "require('cmp_nvim_lsp').default_capabilities()";

      clangd.enable = true;
      rust_analyzer.enable = true;
      ts_ls.enable = true;
      svelte.enable = true;
      html.enable = true;
      cssls.enable = true;
      basedpyright.enable = true;
      gopls.enable = true;
      tinymist.enable = true;
      jsonls.enable = true;
      yamlls.enable = true;
      taplo.enable = true;
      lua_ls.enable = true;
      nixd.enable = true;
      bashls.enable = true;
      dockerls.enable = true;
      marksman.enable = true;
    };
    lsp.inlayHints.enable = true;
    lsp.keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
      }
      {
        key = "gr";
        lspBufAction = "references";
      }
      {
        key = "gI";
        lspBufAction = "implementation";
      }
      {
        key = "gt";
        lspBufAction = "type_definition";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        key = "<leader>rn";
        lspBufAction = "rename";
      }
      {
        key = "<leader>ca";
        mode = [
          "n"
          "v"
        ];
        lspBufAction = "code_action";
      }
      {
        key = "[d";
        action.__raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
      }
      {
        key = "]d";
        action.__raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
      }
    ];

    plugins.luasnip.enable = true;
    plugins.cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
      };
    };

    plugins.supermaven = {
      enable = true;
      settings.keymaps.accept_suggestion = "<S-Space>";
    };

    plugins.neo-tree.enable = true;

    plugins.lualine = {
      enable = true;
      settings.options.theme.__raw = "require('islands-dark.lualine')";
    };

    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;
    plugins.dap-virtual-text.enable = true;
    plugins.dap-lldb = {
      enable = true;
      settings.codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
    };
    plugins.dap-python.enable = true;
    plugins.dap-go.enable = true;
    extraPackages = [ pkgs.delve ];

    plugins.gitsigns.enable = true;
    plugins.octo.enable = true;

    plugins.conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        formatters_by_ft = {
          c = [ "clang_format" ];
          cpp = [ "clang_format" ];
          rust = [ "rustfmt" ];
          go = [
            "gofumpt"
            "goimports"
          ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          svelte = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          toml = [ "taplo" ];
          typst = [ "typstyle" ];
          python = [
            "isort"
            "black"
          ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
        };
      };
    };

    plugins.distant.enable = true;

    plugins.vim-dadbod.enable = true;
    plugins.vim-dadbod-ui.enable = true;
    plugins.vim-dadbod-completion.enable = true;
    globals.db_ui_use_nerd_fonts = 1;

    plugins.wakatime.enable = true;

    extraConfigLua = ''
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    '';

    keymaps = [
      {
        key = "<C-f>";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        key = "<C-d>";
        action = "<Cmd>Neotree toggle<CR>";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<C-A-l>";
        action.__raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
      }
      {
        key = "<F5>";
        action.__raw = "function() require('dap').continue() end";
      }
      {
        key = "<F10>";
        action.__raw = "function() require('dap').step_over() end";
      }
      {
        key = "<F11>";
        action.__raw = "function() require('dap').step_into() end";
      }
      {
        key = "<F12>";
        action.__raw = "function() require('dap').step_out() end";
      }
      {
        key = "<leader>db";
        action.__raw = "function() require('dap').toggle_breakpoint() end";
      }
      {
        key = "<leader>du";
        action.__raw = "function() require('dapui').toggle() end";
      }
    ];
  };
}
