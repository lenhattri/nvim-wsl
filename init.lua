--  ╭──────────────────────────────────────────────────────────╮
--  │                    hisato's neovim                       │
--  ╰──────────────────────────────────────────────────────────╯

-- Byte-compilation cache for Lua modules. Must come before anything is
-- required, including lazy.nvim.
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

require("core.options")
require("core.autocmds")
require("core.keymaps")
require("core.lazy")
require("core.theme").load()
