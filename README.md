# hisato's Neovim

A hand-rolled Neovim config built on [lazy.nvim](https://github.com/folke/lazy.nvim),
cyberpunk-flavoured. No framework (NvChad/LazyVim) — every file is yours, edit freely.

- **Leader key:** `Space`
- **Full keymap reference:** [KEYMAPS.md](KEYMAPS.md)
- **Forgot a key?** Hold `Space` for 0.4s and which-key shows every branch. Or hit
  `Space f k` to search keymaps with Telescope.

---

## Structure

```
~/.config/nvim/
├── init.lua                  loads core/ then lazy.nvim
├── lua/core/
│   ├── options.lua           vim options, diagnostics, WSL clipboard
│   ├── keymaps.lua           plugin-independent keymaps
│   ├── autocmds.lua          autocmds (highlight yank, trim whitespace, …)
│   ├── lazy.lua              bootstrap + lazy.nvim config
│   ├── theme.lua             loads/remembers the colorscheme
│   └── ascii.lua             ASCII art for the dashboard (generated file)
└── lua/plugins/
    ├── theme.lua             12 colorschemes
    ├── ui.lua                lualine, bufferline, noice, indent, cursor…
    ├── dashboard.lua         cyberpunk greeting screen
    ├── editor.lua            telescope, nvim-tree, gitsigns, which-key…
    ├── lsp.lua               mason, lspconfig, navic, conform
    ├── cmp.lua               nvim-cmp + LuaSnip
    └── treesitter.lua        treesitter + textobjects + context
```

Every file in `lua/plugins/` returns a lazy.nvim spec table. Drop a new file into
that directory and it gets loaded automatically — no need to register it anywhere.

---

## Day-to-day work

### Opening files

| What you want | How |
|---|---|
| Open a file by name | `Space Space` (or `Space f f`) |
| Search by content | `Space f g` |
| Search the word under the cursor project-wide | `Space f w` |
| Recently opened files | `Space f r` |
| File tree | `Space e` |
| Search inside the current file | `Space f /` |

Inside Telescope: `Ctrl-j` / `Ctrl-k` to move, `Enter` to open, `Esc` to quit,
`Ctrl-q` to push every result into the quickfix list.

### Editing code with LSP

Servers install themselves through Mason and start automatically when you open a
matching filetype.

| What you want | How |
|---|---|
| Go to definition | `g d` |
| See every usage | `g r` |
| Read the docs | `K` |
| Rename a variable/function | `Space l r` |
| Auto-fix a problem | `Space l a` |
| See the error on the current line | `Space l d` |
| Jump to the next error | `] d` |
| Project-wide error list | `Space x x` |

### Git

| What you want | How |
|---|---|
| Next/previous hunk | `] h` / `[ h` |
| Preview a hunk | `Space g p` |
| Stage a hunk | `Space g h` |
| Reset a hunk | `Space g r` |
| Who touched this line | `Space g B` |
| Diff the whole file | `Space g d` |
| Commit history | `Space g c` |

Inline blame for the current line fades in at the end of the line after 0.5s.
Turn it off with `Space g t`.

### Formatting code

Saving a file formats it (conform.nvim). To disable temporarily:

```vim
:FormatDisable     " disable globally
:FormatDisable!    " disable for the current buffer only
:FormatEnable      " turn it back on
```

Format manually: `Space c f`.

---

## Switching themes

`Space u c` opens a list of 62 themes with **a live preview as you move the cursor**.
Once you pick one, the choice is written to `~/.local/share/nvim/colorscheme` and
applied automatically on the next startup.

The default is `cyberdream`. Change it in `lua/core/theme.lua`:

```lua
local DEFAULT = "cyberdream"
```

The dashboard always keeps its own neon palette and does not follow the theme.

---

## Customising

### Adding a plugin

Create a new file in `lua/plugins/`, e.g. `lua/plugins/extra.lua`:

```lua
return {
  {
    "author-name/plugin-name",
    event = "VeryLazy",        -- load lazily for a fast startup
    opts = { ... },            -- lazy.nvim calls require("name").setup(opts) for you
  },
}
```

Save the file, then `Space L` → `I` to install. Or restart nvim and lazy picks it up.

### Adding an LSP server

Open `lua/plugins/lsp.lua` and add the server name to `ensure_installed`:

```lua
ensure_installed = {
  "lua_ls", "ts_ls", "html", "cssls", "jsonls", "bashls", "pyright",
  "gopls",          -- example: add Go
},
```

Mason downloads it and `automatic_enable` starts it. For custom settings, add:

```lua
vim.lsp.config("gopls", {
  settings = { gopls = { ... } },
})
```

> **Note:** `stylua` is in the `exclude` list of `automatic_enable`.
> nvim-lspconfig ships an `lsp/stylua.lua` file, so mason-lspconfig mistakes
> stylua for a language server and starts it — it exits immediately with code 2.
> stylua is invoked properly by conform.nvim. Other formatters can hit the same
> problem; if you see "Client X quit with exit code", add X to `exclude`.

### Adding a formatter

Two places, both in `lua/plugins/lsp.lua`:

```lua
-- 1. let Mason download it
{ "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = { ensure_installed = { "stylua", "prettierd", "shfmt", "ruff", "gofumpt" } } }

-- 2. map it to a filetype
formatters_by_ft = {
  go = { "gofumpt" },
}
```

### Adding a treesitter language

`lua/plugins/treesitter.lua` → `ensure_installed`. You usually don't need to:
`auto_install` is on, so opening an unfamiliar file fetches the parser by itself.

### Changing the dashboard ASCII art

The art lives in `lua/core/ascii.lua` (`portrait` for wide screens, `uwu` for narrow
ones). To swap it, paste your art there and adjust `ART_W` in
`lua/plugins/dashboard.lua` to match the new art's **width in cells**.

Prefer **braille** art (`⣿⡿⠿`) over block art (`██░░▒▒`): braille packs 8 dots into
a single cell so it looks far smoother, while blocks only have 4 brightness levels
and end up looking pixelated.

---

## How fast does it start

The dashboard shows the real numbers on its last line. To see which plugin is slow:

```vim
:Lazy profile
```

Every plugin is lazy-loaded except the colorscheme group (it has to load early so
`Space u c` can preview) and lualine/bufferline/noice (loaded on `VeryLazy`, i.e.
after the screen has been drawn).

---

## Troubleshooting

| Symptom | Cause & fix |
|---|---|
| Icons show up as boxes | The terminal isn't using a Nerd Font. Install JetBrainsMono Nerd Font, then pick it in Windows Terminal → Settings → profile → Appearance → Font face |
| Treesitter reports a compile error | Missing `gcc`/`make`: `sudo apt install build-essential` |
| Mason can't install a server | Missing `unzip`: `sudo apt install unzip` |
| LSP isn't running | `:LspInfo` to check whether it attached, `:Mason` to check it's installed, `:checkhealth lsp` |
| A plugin broke after an update | `:Lazy restore` to go back to the lockfile, or `:Lazy clean` then `:Lazy sync` |
| Copy/paste doesn't reach Windows | The WSL setup uses `clip.exe` + `powershell.exe`, see `lua/core/options.lua` |
| Terminal too small/large | `C-Up` `C-Down` `C-Left` `C-Right` right inside the terminal. Change the default size via `size`/`float_opts` in `lua/plugins/editor.lua` |
| Want an overall check | `:checkhealth` |

Handy diagnostic commands:

```vim
:Lazy          " plugin manager (I install, U update, X remove, P profile)
:Mason         " LSP/formatter manager (i install, X uninstall)
:LspInfo       " which servers are attached to this buffer
:ConformInfo   " which formatters apply to this buffer
:checkhealth   " check everything
```

---

## System dependencies

Already installed on this machine. If you're setting it up elsewhere:

```bash
sudo apt install build-essential unzip ripgrep fd-find git curl
# nodejs for the JS-based LSPs (ts_ls, html, cssls, jsonls, bashls)
```

| Package | What it's for |
|---|---|
| `build-essential` | compiling treesitter parsers — **required** |
| `unzip` | Mason unpacking LSP archives |
| `ripgrep` | `Space f g` content search |
| `fd-find` | faster file search (the binary is called `fdfind` on Ubuntu) |
| `nodejs` | running the JavaScript-based LSPs |
