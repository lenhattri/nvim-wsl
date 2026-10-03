--  ╭─ Editor ──────────────────────────────────────────────────╮
--  │  file tree, fuzzy finder, git signs, which-key, pairs,     │
--  │  comments, surround, todo, motions, terminal, sessions.    │
--  ╰───────────────────────────────────────────────────────────╯

return {
  -- ── File explorer ──────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>",   desc = "Explorer" },
      { "<leader>o", "<cmd>NvimTreeFocus<CR>",    desc = "Focus explorer" },
      { "<leader>fe", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = {
        width = 34,
        preserve_window_proportions = true,
        signcolumn = "yes",
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = "name",
        indent_markers = { enable = true, icons = { corner = "└", edge = "│", item = "│", none = " " } },
        icons = {
          show = { file = true, folder = true, folder_arrow = true, git = true },
          glyphs = {
            default = "󰈚",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
            git = {
              unstaged = "✗", staged = "✓", unmerged = "", renamed = "➜",
              untracked = "★", deleted = "", ignored = "◌",
            },
          },
        },
      },
      filters = { dotfiles = false, custom = { "^.git$" } },
      git = { enable = true, ignore = false },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = { hint = "󰌵", info = "󰋼", warning = "󰀦", error = "󰅚" },
      },
      actions = { open_file = { quit_on_open = false, resize_window = true } },
    },
  },

  -- ── Fuzzy finder ───────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<CR>",            desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>",                 desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",                  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",                    desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",                   desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",                  desc = "Help tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>",                    desc = "Keymaps" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",       desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>",                desc = "Diagnostics" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>",                desc = "Grep word under cursor" },
      { "<leader>fc", "<cmd>Telescope commands<CR>",                   desc = "Commands" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>",  desc = "Search in buffer" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",                desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",                 desc = "Git status" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>",               desc = "Git branches" },
      { "<leader>uc", "<cmd>Telescope colorscheme<CR>",                desc = "Change theme" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "󰍉   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          sorting_strategy = "ascending",
          results_title = false,
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55, width = 0.90, height = 0.85 },
            vertical = { mirror = false },
          },
          winblend = 0,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          path_display = { "truncate" },
          file_ignore_patterns = { "node_modules", "%.git/", "%.venv", "target/", "dist/" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
              ["<C-u>"] = false,
            },
            n = { ["q"] = actions.close },
          },
        },
        pickers = {
          find_files = { hidden = true },
          colorscheme = { enable_preview = true },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },

  -- ── Git signs ──────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
      preview_config = { border = "rounded" },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map({ "n", "v" }, "<leader>gh", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer,      "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk,   "Undo stage hunk")
        map("n", "<leader>gR", gs.reset_buffer,      "Reset buffer")
        map("n", "<leader>gp", gs.preview_hunk,      "Preview hunk")
        map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gd", gs.diffthis,          "Diff this")
        map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle line blame")
      end,
    },
  },

  -- ── Keymap cheatsheet ──────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = "rounded", padding = { 1, 2 } },
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { "<leader>b", group = "buffer",     icon = "󰓩 " },
        { "<leader>f", group = "find/file",  icon = "󰍉 " },
        { "<leader>g", group = "git",        icon = " " },
        { "<leader>l", group = "lsp",        icon = " " },
        { "<leader>s", group = "search/noice", icon = "󰛔 " },
        { "<leader>u", group = "ui/toggle",  icon = "󰔎 " },
        { "<leader>w", group = "window",     icon = " " },
        { "<leader>x", group = "diagnostics",icon = "󱖫 " },
        { "<leader>t", group = "terminal",   icon = " " },
        { "<leader>c", group = "code",       icon = " " },
        { "[", group = "prev" },
        { "]", group = "next" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  -- ── Auto pairs & tags ──────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
      },
    },
    config = function(_, opts)
      local ap = require("nvim-autopairs")
      ap.setup(opts)
      -- Let <CR> confirm a completion item without breaking pair insertion.
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
      end
    end,
  },

  -- ── Comments ───────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("ts_context_commentstring").setup({ enable_autocmd = false })
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- ── Surround ───────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- ── TODO / FIXME highlighting ──────────────────────────────
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>xt", "<cmd>TodoTrouble<CR>",   desc = "Todo list" },
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find todos" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
    opts = { signs = true },
  },

  -- ── Jump anywhere ──────────────────────────────────────────
  {
    "folke/flash.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = { modes = { char = { jump_labels = true } } },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote flash" },
    },
  },

  -- ── Diagnostics / quickfix panel ───────────────────────────
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true, win = { border = "rounded" } },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>",                  desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle<CR>",                      desc = "LSP references" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   desc = "Quickfix" },
    },
  },

  -- ── Floating terminal ──────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>",     "<cmd>ToggleTerm<CR>",                    mode = { "n", "t" }, desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",    desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Vertical terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>",      desc = "Terminal in its own tab" },
    },
    opts = function()
      -- Float size is remembered for the session: toggleterm rebuilds a float
      -- from float_opts on every open, so persist_size (which only covers
      -- splits) would otherwise throw away any resize.
      local float = {}

      ---Grow or shrink the terminal window, splits and floats alike.
      local function resizer(term, dh, dw)
        return function()
          local win = term.window
          if not win or not vim.api.nvim_win_is_valid(win) then return end
          local cfg = vim.api.nvim_win_get_config(win)

          if cfg.relative ~= "" then
            float.height = math.max(5, math.floor(tonumber(cfg.height) or 0) + dh)
            float.width = math.max(24, math.floor(tonumber(cfg.width) or 0) + dw)
            cfg.height, cfg.width = float.height, float.width
            cfg.row = math.max(0, math.floor((vim.o.lines - float.height) / 2) - 1)
            cfg.col = math.max(0, math.floor((vim.o.columns - float.width) / 2))
            vim.api.nvim_win_set_config(win, cfg)
          elseif dh ~= 0 then
            vim.api.nvim_win_set_height(win, math.max(3, vim.api.nvim_win_get_height(win) + dh))
          else
            vim.api.nvim_win_set_width(win, math.max(24, vim.api.nvim_win_get_width(win) + dw))
          end
        end
      end

      return {
        size = function(term)
          if term.direction == "horizontal" then return 15 end
          if term.direction == "vertical" then return vim.o.columns * 0.4 end
        end,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        persist_size = true,
        direction = "float",
        float_opts = {
          border = "rounded",
          winblend = 0,
          width = function() return float.width or math.floor(vim.o.columns * 0.85) end,
          height = function() return float.height or math.floor(vim.o.lines * 0.8) end,
        },
        -- Resize without leaving the shell: these live in terminal mode too,
        -- and are buffer-local so they never touch a plain :terminal.
        on_open = function(term)
          local function map(lhs, fn, desc)
            vim.keymap.set({ "n", "t" }, lhs, fn, { buffer = term.bufnr, desc = desc })
          end
          map("<C-Up>", resizer(term, 2, 0), "Terminal: taller")
          map("<C-Down>", resizer(term, -2, 0), "Terminal: shorter")
          map("<C-Right>", resizer(term, 0, 6), "Terminal: wider")
          map("<C-Left>", resizer(term, 0, -6), "Terminal: narrower")
        end,
      }
    end,
  },

  -- ── Session restore ────────────────────────────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't save session" },
    },
  },
}
