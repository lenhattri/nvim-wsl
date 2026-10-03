--  ╭─ Treesitter ──────────────────────────────────────────────╮
--  │  syntax highlighting, indent, textobjects, auto-closing    │
--  │  html tags, and a sticky context header.                   │
--  ╰───────────────────────────────────────────────────────────╯

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo" },
    dependencies = {
      -- Pinned to master: the main-branch rewrite dropped the
      -- nvim-treesitter.configs integration the `textobjects` table below
      -- relies on, and silently ignores it.
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = {
        "bash", "c", "css", "diff", "dockerfile", "git_config", "gitcommit",
        "gitignore", "go", "html", "javascript", "jsdoc", "json", "jsonc",
        "lua", "luadoc", "luap", "markdown", "markdown_inline", "python",
        "query", "regex", "rust", "scss", "sql", "toml", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
      },
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, buf)
          -- Skip very large files; treesitter gets slow past ~100 KB.
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 100 * 1024
        end,
      },
      indent = { enable = true, disable = { "python" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "<C-space>",
          node_incremental  = "<C-space>",
          scope_incremental = false,
          node_decremental  = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer", ["if"] = "@function.inner",
            ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",     ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next     = { ["<leader>cs"] = "@parameter.inner" },
          swap_previous = { ["<leader>cS"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-ts-autotag").setup()
    end,
  },

  -- ── Sticky header showing the enclosing function/class ─────
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>ut", "<cmd>TSContextToggle<CR>", desc = "Toggle treesitter context" },
    },
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      separator = "─",
      trim_scope = "outer",
    },
  },
}
