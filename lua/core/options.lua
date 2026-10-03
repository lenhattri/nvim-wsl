local opt = vim.opt

-- ── Appearance ───────────────────────────────────────────────
opt.termguicolors   = true
opt.number          = true
opt.relativenumber  = true
opt.signcolumn      = "yes"
opt.cursorline      = true
opt.cursorlineopt   = "number"
opt.wrap            = false
opt.scrolloff       = 10
opt.sidescrolloff   = 8
opt.pumheight       = 12
opt.pumblend        = 10
opt.winblend        = 0
opt.showmode        = false      -- lualine already shows it
opt.laststatus      = 3          -- one global statusline
opt.cmdheight       = 0          -- noice.nvim takes over
opt.splitbelow      = true
opt.splitright      = true
opt.splitkeep       = "screen"
opt.fillchars = {
  eob    = " ",
  fold   = " ",
  foldopen  = "",
  foldsep   = " ",
  foldclose = "",
  diff   = "╱",
}
opt.list = true
opt.listchars = { tab = "│ ", trail = "·", nbsp = "␣" }

-- ── Editing ──────────────────────────────────────────────────
opt.expandtab    = true
opt.shiftwidth   = 2
opt.tabstop      = 2
opt.softtabstop  = 2
opt.smartindent  = true
opt.breakindent  = true
opt.virtualedit  = "block"
opt.inccommand   = "split"
opt.undofile     = true
opt.undolevels   = 10000
opt.swapfile     = false
opt.backup       = false
opt.updatetime   = 200
opt.timeoutlen   = 400
opt.confirm      = true

-- ── Search ───────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true

-- ── Completion / folds ───────────────────────────────────────
opt.completeopt = { "menu", "menuone", "noselect" }
opt.foldlevel   = 99
opt.foldlevelstart = 99
opt.foldmethod  = "expr"
opt.foldexpr    = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext    = ""

opt.mouse       = "a"
opt.shortmess:append("sIc")
opt.whichwrap:append("<>[]hl")

-- ── WSL clipboard ────────────────────────────────────────────
-- WSLg bridges the Windows clipboard into its own X server, so xclip reads and
-- writes the real Windows clipboard directly — measured under 10ms, against
-- ~350ms for the powershell.exe spawn that every single paste used to pay for.
-- Falls back to clip.exe/powershell where there's no WSLg (Windows 10, or WSLg
-- switched off), which is why the old commands are still here.
if vim.fn.has("wsl") == 1 then
  if vim.env.DISPLAY and vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      name = "WslgXclip",
      copy = {
        ["+"] = { "xclip", "-selection", "clipboard", "-i" },
        ["*"] = { "xclip", "-selection", "clipboard", "-i" },
      },
      paste = {
        ["+"] = { "xclip", "-selection", "clipboard", "-o" },
        ["*"] = { "xclip", "-selection", "clipboard", "-o" },
      },
      cache_enabled = 0,
    }
  else
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      cache_enabled = 0,
    }
  end
end
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- ── Disable unused providers (faster startup) ────────────────
vim.g.loaded_perl_provider   = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider   = 0

-- ── Diagnostics look ─────────────────────────────────────────
vim.diagnostic.config({
  severity_sort = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN]  = "󰀦 ",
      [vim.diagnostic.severity.INFO]  = "󰋼 ",
      [vim.diagnostic.severity.HINT]  = "󰌶 ",
    },
  },
})

-- ── Rounded borders everywhere ───────────────────────────────
vim.o.winborder = "rounded"
