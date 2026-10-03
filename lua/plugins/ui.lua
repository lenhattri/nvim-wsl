--  ╭─ UI ──────────────────────────────────────────────────────╮
--  │  statusline, tabline, dashboard, cmdline, notifications,   │
--  │  indent guides, breadcrumbs, colour hints, cursor trail.   │
--  ╰───────────────────────────────────────────────────────────╯

return {
  -- ── Icons ──────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = { color_icons = true, default = true, strict = true },
  },

  -- ── Statusline ─────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      vim.o.laststatus = 0
    end,
    opts = function()
      local icons = {
        diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = "󰌶 " },
        git = { added = " ", modified = " ", removed = " " },
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "alpha", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = {
            { "mode", icon = "", separator = { left = "" }, right_padding = 2 },
          },
          lualine_b = {
            { "branch", icon = "" },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = icons.diagnostics,
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "" },
            },
          },
          lualine_x = {
            -- recording macro
            {
              function()
                local reg = vim.fn.reg_recording()
                return reg ~= "" and ("󰑊 @" .. reg) or ""
              end,
              color = { fg = "#f38ba8", gui = "bold" },
            },
            -- pending command (noice)
            {
              function() return require("noice").api.status.command.get() end,
              cond = function()
                local ok, noice = pcall(require, "noice")
                return ok and noice.api.status.command.has()
              end,
            },
            {
              "diff",
              symbols = icons.git,
              source = function()
                local gs = vim.b.gitsigns_status_dict
                if gs then
                  return { added = gs.added, modified = gs.changed, removed = gs.removed }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 1, right = 1 } },
          },
          lualine_z = {
            { " %L lines", separator = { right = "" }, left_padding = 2 },
          },
        },
        extensions = { "lazy", "mason", "nvim-tree", "toggleterm", "trouble", "quickfix" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
      vim.o.laststatus = vim.g.lualine_laststatus
    end,
  },

  -- ── Tabline / buffer manager ───────────────────────────────
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",            desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close unpinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>",          desc = "Close other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<CR>",           desc = "Close buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>",            desc = "Close buffers to the left" },
      { "<leader>bd", "<cmd>bdelete<CR>",                        desc = "Delete buffer" },
    },
    opts = {
      options = {
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        separator_style = "slant",
        indicator = { style = "underline" },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { Error = "󰅚 ", Warn = "󰀦 ", Info = "󰋼 " }
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "  Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Redraw after session restore / buffer wipeout
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
    end,
  },

  -- ── Notifications ──────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss notifications",
      },
    },
    opts = {
      timeout = 2500,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width  = function() return math.floor(vim.o.columns * 0.75) end,
      stages = "fade_in_slide_out",
      render = "wrapped-compact",
      fps = 60,
      background_colour = "#000000",
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- ── cmdline / messages / popupmenu ─────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover  = { enabled = true, silent = true },
        signature = { enabled = true },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline     = { pattern = "^:", icon = " ", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up   = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua=", "^=" }, icon = " ", lang = "lua" },
          help        = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
        },
      },
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 70, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
          win_options = { winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" } },
        },
        popupmenu = {
          relative = "editor",
          position = { row = "40%", col = "50%" },
          size = { width = 70, height = 10 },
          border = { style = "rounded", padding = { 0, 1 } },
        },
      },
      routes = {
        -- Mute "written" / "lines yanked" style noise
        { filter = { event = "msg_show", any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d fewer lines" },
            { find = "%d more lines" },
            { find = "written" },
          } }, opts = { skip = true } },
        -- Search count goes to the virtual text, not a message
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      },
    },
    keys = {
      { "<leader>sn", "<cmd>Noice<CR>",         desc = "Noice history" },
      { "<leader>sl", "<cmd>Noice last<CR>",    desc = "Noice last message" },
      { "<leader>sd", "<cmd>NoiceDismiss<CR>",  desc = "Dismiss all" },
      { "<C-f>", function() if not require("noice.lsp").scroll(4)  then return "<C-f>" end end,
        silent = true, expr = true, mode = { "i", "n", "s" }, desc = "Scroll doc down" },
      { "<C-b>", function() if not require("noice.lsp").scroll(-4) then return "<C-b>" end end,
        silent = true, expr = true, mode = { "i", "n", "s" }, desc = "Scroll doc up" },
    },
  },

  -- ── Pretty vim.ui.select / vim.ui.input ────────────────────
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("dressing")
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("dressing")
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = { border = "rounded", win_options = { winblend = 0 } },
      select = { backend = { "telescope", "builtin" }, telescope = nil },
    },
  },

  -- ── Indent guides ──────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "▏", tab_char = "▏" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "nvim-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm", "man",
        },
      },
    },
  },

  -- ── Rainbow brackets ───────────────────────────────────────
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""]   = rd.strategy["global"],
          vim    = rd.strategy["local"],
        },
        query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
        highlight = {
          "RainbowDelimiterYellow", "RainbowDelimiterViolet", "RainbowDelimiterBlue",
          "RainbowDelimiterOrange", "RainbowDelimiterGreen",  "RainbowDelimiterCyan",
          "RainbowDelimiterRed",
        },
      }
    end,
  },

  -- ── Highlight other uses of the word under the cursor ──────
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 150,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      filetypes_denylist = { "alpha", "NvimTree", "lazy", "mason", "Trouble", "toggleterm" },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.keymap.set("n", "]]", function() require("illuminate")["goto_next_reference"](false) end,
        { desc = "Next reference" })
      vim.keymap.set("n", "[[", function() require("illuminate")["goto_prev_reference"](false) end,
        { desc = "Prev reference" })
    end,
  },

  -- ── Inline colour swatches for #rrggbb, rgb(), tailwind ────
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*", "!lazy", "!alpha", "!NvimTree" },
      user_default_options = {
        names = false,
        css = true,
        css_fn = true,
        tailwind = "both",
        mode = "virtualtext",
        virtualtext = "󱓻",
        virtualtext_inline = true,
      },
    },
  },

  -- ── Breadcrumbs (winbar) ───────────────────────────────────
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "LspAttach",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
    opts = {
      attach_navic = true,
      create_autocmd = true,
      show_dirname = false,
      show_basename = true,
      show_modified = true,
      theme = "auto",
      symbols = { separator = "" },
      exclude_filetypes = { "netrw", "toggleterm", "alpha" },
    },
  },

  -- ── Animated cursor trail ──────────────────────────────────
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      hide_target_hack = false,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      legacy_computing_symbols_support = false,
    },
  },

  -- ── Smooth scrolling ───────────────────────────────────────
  {
    "karb94/neoscroll.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      duration_multiplier = 0.6,
      easing = "quadratic",
      performance_mode = false,
    },
  },

  -- ── Zen / focus mode ───────────────────────────────────────
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>uz", "<cmd>ZenMode<CR>", desc = "Zen mode" } },
    dependencies = { "folke/twilight.nvim" },
    opts = {
      window = { backdrop = 0.95, width = 120, options = { number = false, relativenumber = false } },
      plugins = {
        options = { laststatus = 0 },
        twilight = { enabled = true },
      },
    },
  },
}
