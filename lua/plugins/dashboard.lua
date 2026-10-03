--  ╭─ Dashboard ───────────────────────────────────────────────╮
--  │  Cyberpunk start screen. Wide terminals get a neofetch-ish │
--  │  split: neon anime art on the left, the HISATO wordmark,   │
--  │  a system panel and the launcher on the right. Narrow      │
--  │  terminals fall back to a stacked layout.                  │
--  ╰───────────────────────────────────────────────────────────╯

local ascii = require("core.ascii")

-- ── Neon palette ─────────────────────────────────────────────
local NEON = {
  cyan    = "#00e5ff",
  sky     = "#22d3ee",
  blue    = "#38bdf8",
  indigo  = "#818cf8",
  violet  = "#a855f7",
  orchid  = "#d946ef",
  magenta = "#ff2d95",
  pink    = "#ff6ec7",
  amber   = "#ffd166",
  text    = "#c9d7e4",
  dim     = "#5b6478",
}

-- The wordmark burns magenta at the top and cools to cyan at the bottom.
local MARK_GRADIENT = { NEON.magenta, NEON.pink, NEON.orchid, NEON.violet, NEON.indigo, NEON.cyan }
-- The art runs the same gradient in reverse, cyan down to orchid.
local ART_GRADIENT  = { NEON.cyan, NEON.sky, NEON.blue, NEON.indigo, NEON.violet, NEON.orchid }

-- ANSI-Shadow wordmark, 45 columns wide.
local WORDMARK = {
  "██╗  ██╗██╗███████╗ █████╗ ████████╗ ██████╗ ",
  "██║  ██║██║██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗",
  "███████║██║███████╗███████║   ██║   ██║   ██║",
  "██╔══██║██║╚════██║██╔══██║   ██║   ██║   ██║",
  "██║  ██║██║███████║██║  ██║   ██║   ╚██████╔╝",
  "╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ",
}

-- ── Launcher entries, in the order they appear ───────────────
local ACTIONS = {
  { key = "n", icon = "󰎔", label = "New file",        cmd = "<cmd>ene | startinsert<CR>" },
  { key = "f", icon = "󰈞", label = "Find file",       cmd = "<cmd>Telescope find_files<CR>" },
  { key = "o", icon = "󰝰", label = "Open file",       cmd = "<cmd>NvimTreeToggle<CR>" },
  { key = "r", icon = "󰄉", label = "Recent files",    cmd = "<cmd>Telescope oldfiles<CR>" },
  { key = "g", icon = "󰊄", label = "Grep text",       cmd = "<cmd>Telescope live_grep<CR>" },
  { key = "s", icon = "󰦛", label = "Restore session", cmd = "<cmd>lua require('persistence').load()<CR>" },
  { key = "c", icon = "󰒓", label = "Config",          cmd = "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>" },
  { key = "u", icon = "󰏘", label = "Change theme",    cmd = "<cmd>Telescope colorscheme<CR>" },
  { key = "l", icon = "󰒲", label = "Lazy",            cmd = "<cmd>Lazy<CR>" },
  { key = "m", icon = "󰏖", label = "Mason",           cmd = "<cmd>Mason<CR>" },
  { key = "q", icon = "󰅚", label = "Quit",            cmd = "<cmd>qa<CR>" },
}

---Declare every highlight the dashboard paints with. Re-run on each
---colorscheme change so the neon survives a theme switch.
local function set_highlights()
  local hl = vim.api.nvim_set_hl
  for i, c in ipairs(MARK_GRADIENT) do hl(0, "AlphaMark" .. i, { fg = c, bold = true }) end
  for i, c in ipairs(ART_GRADIENT)  do hl(0, "AlphaArt"  .. i, { fg = c }) end
  hl(0, "AlphaRule",     { fg = NEON.violet })
  hl(0, "AlphaTag",      { fg = NEON.magenta, bold = true })
  hl(0, "AlphaBullet",   { fg = NEON.magenta })
  hl(0, "AlphaKey",      { fg = NEON.dim })
  hl(0, "AlphaValue",    { fg = NEON.cyan })
  hl(0, "AlphaIcon",     { fg = NEON.sky })
  hl(0, "AlphaLabel",    { fg = NEON.text })
  hl(0, "AlphaShortcut", { fg = NEON.amber, bold = true })
  hl(0, "AlphaFooter",   { fg = NEON.dim, italic = true })
end

-- ── Layout helpers ───────────────────────────────────────────
local dw = vim.fn.strdisplaywidth

---Pad `s` with spaces until it occupies `w` display cells.
local function pad(s, w)
  return s .. string.rep(" ", math.max(0, w - dw(s)))
end

---Feed the action's keybind, which is how alpha's own buttons fire.
local function presser(cmd)
  return function()
    local keys = vim.api.nvim_replace_termcodes(cmd .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(keys, "t", false)
  end
end

---Three lines of system state for the panel.
local function sysinfo()
  local v = vim.version()
  local ok, lazy = pcall(require, "lazy")
  local uplink = "booting"
  if ok then
    local s = lazy.stats()
    uplink = s.startuptime > 0
      and string.format("%d plugins · %.0f ms", s.count, s.startuptime)
      or string.format("%d plugins", s.count)
  end
  return {
    { "USER",   (vim.env.USER or "user") .. "@" .. (vim.uv.os_gethostname() or "local") },
    { "KERNEL", string.format("neovim %d.%d.%d", v.major, v.minor, v.patch) },
    { "UPLINK", uplink },
  }
end

---Build the right-hand panel as a list of { text, hl, action } rows.
---@param width integer display width every row is padded to
local function panel_rows(width)
  local rows = {}
  local function push(text, hls, action)
    rows[#rows + 1] = { text = text, hl = hls, action = action }
  end

  for i, line in ipairs(WORDMARK) do
    push(line, "AlphaMark" .. i)
  end
  push("")

  local bars = string.rep("▰", 22)
  local function rule(tag)
    push(bars .. "  " .. tag, { { "AlphaRule", 0, #bars }, { "AlphaTag", #bars, -1 } })
  end

  rule("S Y S T E M")
  push("")
  for _, kv in ipairs(sysinfo()) do
    local bullet, key = " ◆ ", pad(kv[1], 9)
    local text = bullet .. key .. kv[2]
    push(text, {
      { "AlphaBullet", 0, #bullet },
      { "AlphaKey", #bullet, #bullet + #key },
      { "AlphaValue", #bullet + #key, -1 },
    })
  end
  push("")
  rule("L A U N C H")
  push("")

  for _, a in ipairs(ACTIONS) do
    local head = "  " .. a.icon .. "   "
    local body = pad(a.label, math.max(1, width - dw(head) - 1))
    push(head .. body .. a.key, {
      { "AlphaIcon", 2, 2 + #a.icon },
      { "AlphaLabel", #head, #head + #a.label },
      { "AlphaShortcut", #head + #body, -1 },
    }, a)
  end

  return rows
end

---Turn a row's relative highlights into absolute ones, offset into the
---composed line by `off` bytes.
local function shift_hl(row, off, out)
  if not row.hl then return end
  if type(row.hl) == "string" then
    out[#out + 1] = { row.hl, off, off + #row.text }
    return
  end
  for _, h in ipairs(row.hl) do
    local stop = h[3] < 0 and (off + #row.text) or (off + h[3])
    out[#out + 1] = { h[1], off + h[2], stop }
  end
end

---One composed line becomes either a plain text element or a button.
local function element(composed, hls, row, cursor)
  if row and row.action then
    return {
      type = "button",
      val = composed,
      on_press = presser(row.action.cmd),
      opts = {
        position = "center",
        cursor = cursor,
        hl = hls,
        keymap = { "n", row.action.key, row.action.cmd, { noremap = true, silent = true, nowait = true } },
      },
    }
  end
  return { type = "text", val = composed, opts = { position = "center", hl = hls } }
end

-- ── Wide: art on the left, panel on the right ────────────────
local ART_W, GAP, PANEL_W = 47, "   ", 45

local function build_wide()
  local art = ascii.portrait
  local rows = panel_rows(PANEL_W)
  -- Whichever column is shorter gets centred against the taller one.
  local art_top  = math.max(0, math.floor((#rows - #art) / 2))
  local rows_top = math.max(0, math.floor((#art - #rows) / 2))
  local height = math.max(#art + art_top, #rows + rows_top)
  local els = {}

  for i = 1, height do
    local art_line = art[i - art_top]
    local left = pad(art_line or "", ART_W)
    local row = rows[i - rows_top]
    local composed = left .. GAP .. pad(row and row.text or "", PANEL_W)
    local off = #left + #GAP
    local hls = {}
    if art_line then
      local n = i - art_top
      local g = math.min(#ART_GRADIENT, math.floor((n - 1) / #art * #ART_GRADIENT) + 1)
      hls[#hls + 1] = { "AlphaArt" .. g, 0, #left }
    end
    shift_hl(row or {}, off, hls)
    els[#els + 1] = element(composed, hls, row, off + 2)
  end

  return {
    { type = "padding", val = 1 },
    { type = "group", val = els, opts = { spacing = 0 } },
    { type = "padding", val = 1 },
  }
end

-- ── Compact: everything stacked ──────────────────────────────
local function build_compact()
  local els = {}
  local art = ascii.uwu
  local width = 42

  for i, line in ipairs(art) do
    local g = math.min(#ART_GRADIENT, math.floor((i - 1) / #art * #ART_GRADIENT) + 1)
    els[#els + 1] = { type = "text", val = line, opts = { position = "center", hl = "AlphaArt" .. g } }
  end
  els[#els + 1] = { type = "padding", val = 1 }

  for i, line in ipairs(WORDMARK) do
    els[#els + 1] = { type = "text", val = line, opts = { position = "center", hl = "AlphaMark" .. i } }
  end
  els[#els + 1] = { type = "padding", val = 1 }

  -- One condensed system line, standing in for the wide layout's panel.
  local info = sysinfo()
  local sys = info[1][2] .. "  ·  " .. info[2][2] .. "  ·  " .. info[3][2]
  els[#els + 1] = { type = "text", val = sys, opts = { position = "center", hl = "AlphaKey" } }
  els[#els + 1] = { type = "padding", val = 1 }

  local bars = string.rep("▰", 13)
  local tagline = bars .. "  L A U N C H  " .. bars
  els[#els + 1] = {
    type = "text",
    val = tagline,
    opts = { position = "center", hl = {
      { "AlphaRule", 0, #bars },
      { "AlphaTag", #bars, #bars + #"  L A U N C H  " },
      { "AlphaRule", #bars + #"  L A U N C H  ", -1 },
    } },
  }
  els[#els + 1] = { type = "padding", val = 1 }

  for _, a in ipairs(ACTIONS) do
    local head = "  " .. a.icon .. "   "
    local body = pad(a.label, math.max(1, width - dw(head) - 1))
    local composed = head .. body .. a.key
    els[#els + 1] = element(composed, {
      { "AlphaIcon", 2, 2 + #a.icon },
      { "AlphaLabel", #head, #head + #a.label },
      { "AlphaShortcut", #head + #body, -1 },
    }, { text = composed, action = a }, 2)
  end

  return {
    { type = "padding", val = 1 },
    { type = "group", val = els, opts = { spacing = 0 } },
    { type = "padding", val = 1 },
  }
end

---Footer: one dim line with the startup stats, under either layout.
local function footer()
  local ok, lazy = pcall(require, "lazy")
  local text = "// jacking in"
  if ok then
    local s = lazy.stats()
    text = s.startuptime > 0
      and string.format("// %d of %d modules online in %.0f ms", s.loaded, s.count, s.startuptime)
      or string.format("// %d modules linked", s.count)
  end
  return { type = "text", val = text, opts = { position = "center", hl = "AlphaFooter" } }
end

---Pick a layout for the current window size and hand it to alpha.
local function render()
  local alpha = require("alpha")
  local wide = vim.o.columns >= (ART_W + #GAP + PANEL_W + 4)
  local layout = wide and build_wide() or build_compact()
  layout[#layout + 1] = footer()
  alpha.setup({ layout = layout, opts = { margin = 0 } })
  if vim.bo.filetype == "alpha" then
    pcall(vim.cmd.AlphaRedraw)
  end
end

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local group = vim.api.nvim_create_augroup("hisato_alpha", { clear = true })

      set_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })

      render()

      -- Redraw once lazy.nvim reports its timings, and whenever the
      -- terminal is resized across the wide/compact threshold.
      vim.api.nvim_create_autocmd("User", { group = group, pattern = "VeryLazy", once = true, callback = render })
      vim.api.nvim_create_autocmd("VimResized", { group = group, callback = render })

      -- Hide the tabline while the dashboard is up.
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "AlphaReady",
        callback = function()
          local saved = vim.o.showtabline
          vim.o.showtabline = 0
          vim.api.nvim_create_autocmd("BufUnload", {
            buffer = 0,
            once = true,
            callback = function() vim.o.showtabline = saved end,
          })
        end,
      })
    end,
  },
}
