--  ╭─ Images ──────────────────────────────────────────────────╮
--  │  Real pictures in the terminal: open a .png like any file, │
--  │  and see markdown image links rendered in place.           │
--  ╰───────────────────────────────────────────────────────────╯

return {
  {
    "3rd/image.nvim",
    -- No luarock: the magick_cli processor shells out to ImageMagick instead,
    -- which keeps lazy.nvim's `rocks` bootstrap switched off.
    build = false,
    ft = { "markdown", "vimwiki", "norg", "asciidoc" },
    -- Opening an image file has to work from a cold start, so load on the
    -- pattern too rather than waiting for a markdown buffer.
    event = {
      {
        event = "BufReadPre",
        pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      },
    },
    -- Without ImageMagick the backend only logs an error on every render.
    cond = function()
      return vim.fn.executable("magick") == 1 or vim.fn.executable("convert") == 1
    end,
    opts = function()
      -- Kitty's graphics protocol is the good path, but only some terminals
      -- speak it. Windows Terminal (which is what WSL usually runs in) does
      -- sixel instead, as of 1.22.
      -- WezTerm speaks it too, but image.nvim's own README calls its
      -- implementation slow and incomplete, so it stays on sixel.
      local term = vim.env.TERM or ""
      local kitty_graphics = vim.env.KITTY_WINDOW_ID ~= nil
        or vim.env.GHOSTTY_RESOURCES_DIR ~= nil
        or vim.env.TERM_PROGRAM == "ghostty"
        or term:match("kitty") ~= nil
        or term:match("ghostty") ~= nil

      return {
        backend = kitty_graphics and "kitty" or "sixel",
        processor = "magick_cli",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            -- Only draw what the cursor is near; a doc full of screenshots
            -- otherwise re-encodes every one of them on each scroll.
            only_render_image_at_cursor = true,
            filetypes = { "markdown", "vimwiki" },
          },
          neorg = { enabled = true },
          asciidoc = { enabled = true },
          typst = { enabled = false },
          syslang = { enabled = false },
        },
        max_width_window_percentage = 100,
        max_height_window_percentage = 100,
        -- Must stay off (it is upstream's default). It makes the renderer
        -- bail with "overlap" whenever another window masks the image one —
        -- and nvim-tree counts, so with the tree open an image never draws.
        -- The cost of leaving it off is that a float can let an image bleed
        -- through; the cost of turning it on is no images at all.
        window_overlap_clear_enabled = false,
        -- Stop drawing while the terminal is in the background, so an
        -- alt-tabbed nvim doesn't leave images painted over other windows.
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = true,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      }
    end,
    config = function(_, opts)
      require("image").setup(opts)
      if opts.backend ~= "sixel" then return end

      -- Sixel pixels live in the text grid, so anything nvim draws over an
      -- image erases it — and the backend only repaints when the geometry
      -- changes, so a redraw silently leaves a blank hole. Nudge it after
      -- every redraw-ish event instead. Cheap: the encoded sixel is cached
      -- by path+size, so a repaint is a write, not another ImageMagick run.
      local timer = nil
      local function repaint()
        if timer then timer:stop() end
        timer = vim.defer_fn(function()
          timer = nil
          local image = require("image")
          if not image.is_enabled() then return end
          for _, img in ipairs(image.get_images()) do
            -- Shallow clear drops it from the frame without forgetting it,
            -- which is what makes the following render actually repaint.
            img:clear(true)
            img:render()
          end
        end, 150)
      end

      local group = vim.api.nvim_create_augroup("image_sixel_repaint", { clear = true })
      vim.api.nvim_create_autocmd({
        -- Deliberately short: every repaint forces a full redraw and re-sends
        -- the frame, which reads as a blink. Cursor movement is left out —
        -- with cursorline off in image buffers and smear-cursor disabled,
        -- moving the cursor no longer erases anything.
        "WinScrolled", "WinResized", "VimResized", "InsertLeave",
        "WinEnter", "TabEnter", "FocusGained", "CmdlineLeave",
        -- A float (which-key, noice, telescope) covers the image while it's
        -- open and leaves a hole behind when it goes.
        "WinClosed",
      }, { group = group, callback = repaint })

      -- The cursor line is drawn on every move and sits right on top of the
      -- picture; in an image buffer there's no text for it to highlight.
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "image_nvim",
        callback = function()
          vim.opt_local.cursorline = false
          vim.opt_local.list = false
        end,
      })
    end,
    keys = {
      {
        "<leader>ui",
        function()
          -- No toggle in the API, just the two halves of one.
          local image = require("image")
          if image.is_enabled() then image.disable() else image.enable() end
        end,
        desc = "Toggle image rendering",
      },
    },
  },
}
