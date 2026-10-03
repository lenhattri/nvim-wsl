--  ╭─ LSP ─────────────────────────────────────────────────────╮
--  │  mason installs the servers, nvim-lspconfig ships their    │
--  │  configs as lsp/*.lua, and Neovim 0.11 enables them.       │
--  ╰───────────────────────────────────────────────────────────╯

return {
  -- ── Server installer ───────────────────────────────────────
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        backdrop = 100,
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      { "j-hui/fidget.nvim", opts = {
          progress = { display = { done_icon = "󰄬" } },
          notification = { window = { winblend = 0, border = "rounded" } },
      } },
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "bashls",
        "pyright",
      },
      -- v2 enables every installed server through vim.lsp.enable() for us.
      -- nvim-lspconfig ships an lsp/stylua.lua, so mason-lspconfig would
      -- otherwise start the stylua *formatter* as a language server and it
      -- exits immediately. conform.nvim drives stylua instead.
      automatic_enable = { exclude = { "stylua" } },
    },
    config = function(_, opts)
      -- Per-server overrides. nvim-lspconfig supplies the defaults; these
      -- are merged on top by vim.lsp.config().
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
            hint = { enable = true, arrayIndex = "Disable" },
            telemetry = { enable = false },
          },
        },
      })

      require("mason-lspconfig").setup(opts)

      -- ── Buffer-local keymaps once a server attaches ──────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("hisato_lsp_attach", { clear = true }),
        callback = function(ev)
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          map("gd", "<cmd>Telescope lsp_definitions<CR>",      "Go to definition")
          map("gr", "<cmd>Telescope lsp_references<CR>",       "References")
          map("gI", "<cmd>Telescope lsp_implementations<CR>",  "Implementations")
          map("gy", "<cmd>Telescope lsp_type_definitions<CR>", "Type definition")
          map("gD", vim.lsp.buf.declaration,                   "Go to declaration")
          map("K",  function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover docs")
          map("gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
          map("<leader>lr", vim.lsp.buf.rename,                "Rename")
          map("<leader>la", vim.lsp.buf.code_action,           "Code action", { "n", "v" })
          map("<leader>ld", vim.diagnostic.open_float,         "Line diagnostics")
          map("<leader>li", "<cmd>LspInfo<CR>",                "LSP info")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end

          -- Breadcrumbs source for barbecue.
          if client:supports_method("textDocument/documentSymbol") then
            pcall(function() require("nvim-navic").attach(client, ev.buf) end)
          end

          -- Inlay hints, toggleable.
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },

  -- ── Auto-install the formatters conform.nvim expects ──────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettierd",
        "shfmt",
        "ruff",
      },
      run_on_start = true,
      start_delay = 2000,
      auto_update = false,
    },
  },

  -- ── Breadcrumb data source ─────────────────────────────────
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      highlight = true,
      separator = "  ",
      depth_limit = 5,
      icons = {
        File = "󰈙 ", Module = "󰆼 ", Namespace = "󰌗 ", Package = "󰏖 ",
        Class = "󰌗 ", Method = "󰆧 ", Property = "󰜢 ", Field = "󰆨 ",
        Constructor = "󰆧 ", Enum = "󰕘", Interface = "󰕘", Function = "󰊕 ",
        Variable = "󰆧 ", Constant = "󰏿 ", String = "󰀬 ", Number = "󰎠 ",
        Boolean = "◩ ", Array = "󰅪 ", Object = "󰅩 ", Key = "󰌋 ",
        Null = "󰟢 ", EnumMember = "󰒻 ", Struct = "󰌗 ", Event = "󰉁 ",
        Operator = "󰆕 ", TypeParameter = "󰊄 ",
      },
    },
  },

  -- ── Formatting ─────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json       = { "prettierd", "prettier", stop_after_first = true },
        html       = { "prettierd", "prettier", stop_after_first = true },
        css        = { "prettierd", "prettier", stop_after_first = true },
        markdown   = { "prettierd", "prettier", stop_after_first = true },
        python     = { "ruff_format" },
        sh         = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- :FormatDisable / :FormatEnable toggle it off per buffer or globally.
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { desc = "Disable format on save (! = buffer only)", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable format on save" })
    end,
  },
}
