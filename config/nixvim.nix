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
      pkgs.vimPlugins.vim-svelte
    ];

    opts = {
      number = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoread = true;
      updatetime = 250;
      signcolumn = "yes";
      scrolloff = 4;
    };

    autoCmd = [
      {
        event = "VimEnter";
        once = true;
        callback.__raw = ''
          function()
            vim.schedule(function()
              vim.o.clipboard = "unnamedplus"
            end)
          end
        '';
      }
      {
        event = [
          "FocusGained"
          "BufEnter"
        ];
        pattern = "*";
        callback.__raw = ''
          function()
            if vim.fn.mode() ~= "c" then
              vim.cmd("checktime")
            end
          end
        '';
      }
      {
        event = "FileChangedShellPost";
        pattern = "*";
        command = "echohl WarningMsg | echo 'File changed on disk, buffer reloaded' | echohl None";
      }
      {
        event = "BufReadPost";
        pattern = "*";
        callback.__raw = ''
          function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(500, vim.fn.line("$")), false)
            for _, line in ipairs(lines) do
              if string.find(line, "\0", 1, true) then
                pcall(vim.cmd, "HexDump")
                return
              end
            end
          end
        '';
      }
      {
        event = "FileType";
        pattern = [
          "python"
          "rust"
          "c"
          "cpp"
        ];
        callback.__raw = ''
          function()
            vim.bo.tabstop = 4
            vim.bo.softtabstop = 4
            vim.bo.shiftwidth = 4
          end
        '';
      }
      {
        event = "FileType";
        pattern = [ "go" ];
        callback.__raw = ''
          function()
            vim.bo.tabstop = 4
            vim.bo.softtabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.expandtab = false
          end
        '';
      }
    ];

    plugins.web-devicons.enable = true;
    plugins.treesitter = {
      enable = true;
      settings.highlight.enable = true;
      settings.indent.enable = true;
      highlight.disable = [ "svelte" ];
    };

    plugins.refactoring.enable = true;
    plugins.nvim-autopairs.enable = true;
    plugins.ts-autotag.enable = true;
    plugins.auto-save = {
      enable = true;
      settings.trigger_events.immediate_save = [
        "BufLeave"
        "FocusLost"
        "WinLeave"
        "TabLeave"
        "VimLeavePre"
      ];
    };

    highlight = {
      RainbowBlue.fg = "#56a8f5";
      RainbowPurple.fg = "#c77dbb";
    };
    plugins.rainbow-delimiters = {
      enable = true;
      settings.highlight = [
        "RainbowBlue"
        "RainbowPurple"
      ];
    };

    highlightOverride = {
      Keyword.fg = "#c77dbb";
      Conditional.fg = "#c77dbb";
      Repeat.fg = "#c77dbb";
      Statement.fg = "#c77dbb";
      "@keyword".fg = "#c77dbb";
      "@keyword.function".fg = "#c77dbb";
      "@keyword.return".fg = "#c77dbb";
      "@conditional".fg = "#c77dbb";
      "@repeat".fg = "#c77dbb";

      Type.fg = "#56a8f5";
      "@type".fg = "#56a8f5";
      "@type.builtin".fg = "#56a8f5";
    };
    plugins.lsp-signature = {
      enable = true;
      settings.toggle_key = "<C-k>";
    };

    plugins.telescope.enable = true;
    plugins.telescope.settings = {
      defaults.file_ignore_patterns = [ "^.git/" ];
      pickers.find_files.hidden = true;
    };
    plugins.telescope.extensions.file-browser = {
      enable = true;
      settings.hijack_netrw = true;
      settings.hidden.file_browser = true;
    };

    plugins.grug-far.enable = true;

    plugins.claudecode = {
      enable = true;
      settings.terminal.split_side = "right";
    };

    plugins.lspconfig.enable = true;
    lsp.servers = {
      "*".config.capabilities.__raw = "require('cmp_nvim_lsp').default_capabilities()";

      clangd.enable = true;
      asm_lsp.enable = true;
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
        key = "<F2>";
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
      # Needs the kitty keyboard protocol to reach Neovim at all; a terminal
      # without it never sends Ctrl+. and <leader>ca stays the way in.
      {
        key = "<C-.>";
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
        completion.completeopt = "menu,menuone,noselect";
        performance.max_view_entries = 16;

        # Explicit priorities so LSP results outrank raw buffer words; buffer
        # only joins in once there is enough of a prefix to be meaningful.
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "path";
            priority = 500;
          }
          {
            name = "buffer";
            priority = 250;
            keyword_length = 3;
          }
        ];

        # Default order leads with offset/exact, which buries a good fuzzy hit
        # under whatever happens to start at the cursor. Score and previous
        # picks come first here, then proximity in the buffer.
        sorting = {
          priority_weight = 2;
          comparators = [
            { __raw = "require('cmp').config.compare.exact"; }
            { __raw = "require('cmp').config.compare.score"; }
            { __raw = "require('cmp').config.compare.recently_used"; }
            { __raw = "require('cmp').config.compare.locality"; }
            { __raw = "require('cmp').config.compare.offset"; }
            { __raw = "require('cmp').config.compare.kind"; }
            { __raw = "require('cmp').config.compare.length"; }
            { __raw = "require('cmp').config.compare.order"; }
          ];
        };
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, true, true), "n", true)
              end
            end, { "i", "s" })
          '';
        };
      };
    };

    plugins.supermaven = {
      enable = true;
      settings.keymaps.accept_suggestion = "<C-a>";
      settings.condition.__raw = "function() return not vim.g.ai_enabled end";
    };

    plugins.neo-tree = {
      enable = true;
      settings = {
        window = {
          position = "right";
          width = 36;
        };
        default_component_configs.diagnostics = {
          symbols = {
            error = "";
            warn = "";
            info = "";
            hint = "";
          };
          highlights = {
            error = "DiagnosticSignError";
            warn = "DiagnosticSignWarn";
            info = "DiagnosticSignInfo";
            hint = "DiagnosticSignHint";
          };
        };
      };
    };

    plugins.lualine = {
      enable = true;
      settings.options.theme.__raw = "require('islands-dark.lualine')";
      settings.sections.lualine_c = [
        {
          __unkeyed-1 = "filename";
          path = 1;
        }
      ];
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
    plugins.neogit.enable = true;
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
    globals.mapleader = " ";
    globals.maplocalleader = " ";
    globals.db_ui_use_nerd_fonts = 1;

    plugins.wakatime.enable = true;

    plugins.hex = {
      enable = true;
      settings = {
        dump_cmd = "xxd -g 1 -u";
        assemble_cmd = "xxd -r";
      };
    };

    userCommands.Cheatsheet = {
      desc = "Show a cheatsheet of configured keybinds";
      command.__raw = ''
        function()
          local lines = {
            "-- General --",
            "<C-f>         Find files (Telescope)",
            "<C-S-f>       Search text across project (Telescope)",
            "<C-v>         Open Telescope selection in vertical split",
            "<C-x>         Open Telescope selection in horizontal split",
            "<C-S-Left>    Previous buffer",
            "<C-S-Right>   Next buffer",
            "<C-n>         New file (Telescope file browser)",
            "<C-d>         Toggle file explorer (Neo-tree)",
            "<leader>cc    Toggle Claude Code panel",
            "<C-p>         Toggle cursor visibility",
            "<C-;>         Toggle line comment",
            "<C-S-i>       Format buffer",
            "<leader>ai    Toggle AI suggestions (Supermaven)",
            "<leader>gg    Open Neogit",
            "<leader>gs    Git status (hover to diff, <Tab> to stage)",
            "<leader>hx    Toggle hex view (hex.nvim)",
            "",
            "-- Completion (insert mode) --",
            "<C-Space>     Open completion menu",
            "<Tab>         Next item",
            "<C-a>         Accept AI suggestion",
            "<S-Tab>       Previous item / dedent",
            "<CR>          Confirm completion",
            "<C-e>         Abort completion",
            "",
            "-- LSP --",
            "gd            Go to definition",
            "gD            Go to declaration",
            "gr            Go to references",
            "gI            Go to implementation",
            "gt            Go to type definition",
            "K             Hover docs",
            "<C-k>         Toggle signature-help popup (insert mode)",
            "<F2>          Rename symbol",
            "<S-F2>        Project-wide find and replace (grug-far)",
            "<leader>rn    Rename symbol",
            "<leader>ca    Code action",
            "<C-.>         Quick fix / code action menu",
            "[d / ]d       Previous / next diagnostic",
            "",
            "-- Debugging --",
            "<F5>          Continue",
            "<F10>         Step over",
            "<F11>         Step into",
            "<F12>         Step out",
            "<leader>db    Toggle breakpoint",
            "<leader>du    Toggle debug UI",
            "",
            "-- Refactoring (visual mode) --",
            "<leader>rf    Extract function",
            "<leader>rv    Extract variable",
            "",
            "q or <Esc> to close",
          }

          local width = 0
          for _, line in ipairs(lines) do
            width = math.max(width, #line)
          end
          width = width + 4

          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].modifiable = false

          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = #lines,
            row = math.floor((vim.o.lines - #lines) / 2),
            col = math.floor((vim.o.columns - width) / 2),
            style = "minimal",
            border = "rounded",
            title = " Keybinds ",
            title_pos = "center",
          })

          vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = buf, silent = true })
          vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = buf, silent = true })
        end
      '';
    };

    extraConfigLua = ''
      -- Suppress clang's -Wint-to-void-pointer-cast diagnostic (host pointer
      -- width is 64-bit; real-mode near pointers are always smaller).
      do
        local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
        vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          if result and result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(d)
              return not (d.source == "clang" and d.code == "-Wint-to-void-pointer-cast")
            end, result.diagnostics)
          end
          return orig(err, result, ctx, config)
        end
      end

      -- Diagnostics sit to the right of the code and wrap onto extra virtual
      -- lines rather than running off the window edge. Built-in virtual_text
      -- never wraps and virtual_lines always starts below the code line.
      do
        local MAX_LINES = 4
        local hl_map = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
          [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
        }

        local function ellipsize(s, width)
          while vim.fn.strdisplaywidth(s .. "...") > width and vim.fn.strchars(s) > 0 do
            s = vim.fn.strcharpart(s, 0, vim.fn.strchars(s) - 1)
          end
          return s .. "..."
        end

        -- The first row shares the code line, so it gets less room than the rest.
        local function wrap(msg, first_w, cont_w)
          local words = {}
          for word in msg:gmatch("%S+") do
            words[#words + 1] = word
          end

          local out, cur, i = {}, "", 1
          while i <= #words do
            local width = (#out == 0) and first_w or cont_w
            local cand = (cur == "") and words[i] or (cur .. " " .. words[i])
            if vim.fn.strdisplaywidth(cand) <= width then
              cur, i = cand, i + 1
            else
              if cur == "" then
                cur = vim.fn.strcharpart(words[i], 0, width)
                words[i] = vim.fn.strcharpart(words[i], width)
              end
              out[#out + 1], cur = cur, ""
              if #out == MAX_LINES then
                out[MAX_LINES] = ellipsize(out[MAX_LINES], MAX_LINES == 1 and first_w or cont_w)
                return out
              end
            end
          end
          if cur ~= "" then
            out[#out + 1] = cur
          end
          return out
        end

        local function render(ns, bufnr, diagnostics)
          local winid = vim.fn.bufwinid(bufnr)
          local text_width = vim.o.columns
          if winid ~= -1 then
            local info = vim.fn.getwininfo(winid)[1]
            text_width = vim.api.nvim_win_get_width(winid) - (info and info.textoff or 0)
          end

          local by_line = {}
          for _, d in ipairs(diagnostics) do
            by_line[d.lnum] = by_line[d.lnum] or {}
            table.insert(by_line[d.lnum], d)
          end

          for lnum, list in pairs(by_line) do
            local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
            if line then
              table.sort(list, function(a, b)
                return (a.severity or 1) < (b.severity or 1)
              end)
              local d = list[1]
              local hl = hl_map[d.severity] or hl_map[vim.diagnostic.severity.ERROR]
              -- Continuation rows pull their indent back when the code line
              -- leaves too little room, so they never spill past the edge.
              local col = vim.fn.strdisplaywidth(line) + 1
              local pad = math.max(math.min(col, text_width - 40), 0)
              local cont_w = math.max(text_width - pad - 1, 1)
              local room = text_width - col - 1
              local inline = room >= 12
              local lines = wrap(vim.trim(d.message:gsub("%s+", " ")), inline and room or cont_w, cont_w)

              if #lines > 0 then
                local mark = { hl_mode = "combine" }
                if inline then
                  mark.virt_text = { { " " .. lines[1], hl } }
                  mark.virt_text_pos = "eol"
                end

                local virt_lines = {}
                for i = inline and 2 or 1, #lines do
                  virt_lines[#virt_lines + 1] = {
                    { string.rep(" ", pad), "Normal" },
                    { lines[i], hl },
                  }
                end
                if #virt_lines > 0 then
                  mark.virt_lines = virt_lines
                end

                vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, mark)
              end
            end
          end
        end

        local function child_ns(namespace)
          local ns = vim.diagnostic.get_namespace(namespace)
          if not ns.user_data.wrapped_virt_ns then
            ns.user_data.wrapped_virt_ns =
              vim.api.nvim_create_namespace("wrapped_virt_text." .. namespace)
          end
          return ns.user_data.wrapped_virt_ns
        end

        vim.diagnostic.handlers.wrapped_virtual_text = {
          show = function(namespace, bufnr, diagnostics, _)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            local ns = child_ns(namespace)
            vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
            render(ns, bufnr, diagnostics)
          end,
          hide = function(namespace, bufnr)
            local ns = vim.diagnostic.get_namespace(namespace).user_data.wrapped_virt_ns
            if ns and vim.api.nvim_buf_is_valid(bufnr) then
              vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
            end
          end,
        }

        -- wrap width is window-relative, so it has to be recomputed on resize
        vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
          callback = function()
            vim.schedule(function()
              vim.diagnostic.show()
            end)
          end,
        })
      end

      -- must run after plugin setup; an earlier call gets reset
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        wrapped_virtual_text = true,
      })

      -- OSC 52 copy, register-backed paste. Spawning wl-copy triggers a GNOME
      -- notification per yank, and Alacritty refuses OSC 52 reads, so a real
      -- OSC 52 paste would stall for its full timeout on every put.
      do
        local osc52 = require("vim.ui.clipboard.osc52")
        local cached = {}
        local function copy(reg)
          local send = osc52.copy(reg)
          return function(lines, regtype)
            cached[reg] = { lines, regtype or "v" }
            send(lines, regtype)
          end
        end
        local function paste(reg)
          return function()
            return cached[reg] or { vim.fn.getreg('"', 1, true), vim.fn.getregtype('"') }
          end
        end
        vim.g.clipboard = {
          name = "osc52-copy-only",
          copy = { ["+"] = copy("+"), ["*"] = copy("*") },
          paste = { ["+"] = paste("+"), ["*"] = paste("*") },
          cache_enabled = 0,
        }
      end

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
        key = "<C-S-f>";
        action = "<cmd>Telescope live_grep<cr>";
      }
      {
        key = "<S-F2>";
        action.__raw = "function() require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } }) end";
      }
      {
        key = "<leader>gg";
        action = "<cmd>Neogit<cr>";
      }
      {
        key = "<leader>gs";
        action = "<cmd>Telescope git_status<cr>";
      }
      {
        key = "<leader>ai";
        action.__raw = ''
          function()
            local api = require('supermaven-nvim.api')
            vim.g.ai_enabled = not vim.g.ai_enabled
            if vim.g.ai_enabled then
              api.start()
            elseif api.is_running() then
              api.stop()
            end
            local state = vim.g.ai_enabled and "on" or "off"
            vim.notify("AI suggestions turned " .. state, vim.log.levels.INFO)
          end
        '';
      }
      {
        mode = "n";
        key = "<C-;>";
        options.expr = true;
        action.__raw = "function() return require('vim._comment').operator() .. '_' end";
      }
      {
        mode = "x";
        key = "<C-;>";
        options.expr = true;
        action.__raw = "function() return require('vim._comment').operator() end";
      }
      {
        key = "<C-d>";
        action = "<Cmd>Neotree toggle<CR>";
      }
      {
        key = "<C-S-Left>";
        action = "<Cmd>bprevious<CR>";
      }
      {
        key = "<C-S-Right>";
        action = "<Cmd>bnext<CR>";
      }
      {
        key = "<C-n>";
        action.__raw = ''
          function()
            require("telescope").extensions.file_browser.file_browser({
              path = "%:p:h",
              select_buffer = true,
            })
          end
        '';
      }
      {
        mode = "n";
        key = "<leader>cc";
        action = "<Cmd>ClaudeCode<CR>";
      }
      {
        key = "<C-p>";
        action.__raw = ''
          function()
            vim.g.__cursor_hidden = not vim.g.__cursor_hidden
            if vim.g.__cursor_hidden then
              local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
              if not bg then
                vim.g.__cursor_hidden = false
                vim.notify("Cannot hide cursor: colorscheme has no Normal background", vim.log.levels.WARN)
                return
              end
              vim.g.__saved_guicursor = vim.o.guicursor
              vim.api.nvim_set_hl(0, "HiddenCursor", { fg = bg, bg = bg })
              vim.o.guicursor = "a:HiddenCursor"
            else
              vim.o.guicursor = vim.g.__saved_guicursor or ""
            end
          end
        '';
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<C-S-i>";
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
      {
        mode = "x";
        key = "<leader>rf";
        action.__raw = "function() return require('refactoring').extract_func() end";
        options.expr = true;
      }
      {
        mode = "x";
        key = "<leader>rv";
        action.__raw = "function() return require('refactoring').extract_var() end";
        options.expr = true;
      }
    ];
  };
}
