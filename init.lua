--  ╭──────────────────────────────────────────────────────────╮
--  │                    hisato's neovim                       │
--  ╰──────────────────────────────────────────────────────────╯

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

require("core.options")
require("core.autocmds")
require("core.keymaps")
require("core.lazy")
require("core.theme").load()
