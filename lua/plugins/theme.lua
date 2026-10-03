--  ╭─ Themes ─────────────────────────────────────────────────╮
--  │  All loaded eagerly so the <leader>uc picker can live-    │
--  │  preview every one of them. Choice persists across        │
--  │  restarts (see lua/core/theme.lua).                       │
--  ╰───────────────────────────────────────────────────────────╯

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = { enabled = false },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "italic" },
        functions = { "bold" },
        types = { "italic" },
      },
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true, colored_indent_levels = false },
        mason = true,
        markdown = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "NONE" },
        noice = true,
        notify = true,
        nvimtree = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(C)
        return {
          -- A little more contrast on the active window separator
          WinSeparator = { fg = C.surface1 },
          -- Keep the cursorline number bright enough to track
          CursorLineNr = { fg = C.peach, style = { "bold" } },
        }
      end,
    },
  },

  { "folke/tokyonight.nvim",   lazy = false, priority = 900,
    opts = { style = "night", styles = { comments = { italic = true } }, lualine_bold = true } },

  { "rose-pine/neovim",        name = "rose-pine", lazy = false, priority = 900,
    opts = { variant = "main", styles = { italic = true, transparency = false } } },

  { "rebelot/kanagawa.nvim",   lazy = false, priority = 900,
    opts = { theme = "wave", commentStyle = { italic = true }, keywordStyle = { italic = true } } },

  { "EdenEast/nightfox.nvim",  lazy = false, priority = 900 },
  { "sainnhe/everforest",      lazy = false, priority = 900,
    config = function() vim.g.everforest_background = "hard"; vim.g.everforest_better_performance = 1 end },
  { "sainnhe/gruvbox-material", lazy = false, priority = 900,
    config = function() vim.g.gruvbox_material_background = "medium"; vim.g.gruvbox_material_better_performance = 1 end },
  { "nyoom-engineering/oxocarbon.nvim", lazy = false, priority = 900 },
  { "navarasu/onedark.nvim",   lazy = false, priority = 900, opts = { style = "deep" } },
  { "shaunsingh/nord.nvim",    lazy = false, priority = 900 },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 900,
    opts = { italic_comments = true, borderless_pickers = false } },
  { "savq/melange-nvim",       lazy = false, priority = 900 },
}
