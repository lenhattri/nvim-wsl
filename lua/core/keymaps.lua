local map = vim.keymap.set

-- ── Basics ───────────────────────────────────────────────────
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- ── Better movement ──────────────────────────────────────────
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down + center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up + center" })
map("n", "n", "nzzzv", { desc = "Next match + center" })
map("n", "N", "Nzzzv", { desc = "Prev match + center" })

-- ── Window navigation ────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ── Splits ───────────────────────────────────────────────────
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wd", "<C-w>q", { desc = "Close window" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize windows" })

-- ── Buffers ──────────────────────────────────────────────────
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bb", "<cmd>e #<CR>",  { desc = "Alternate buffer" })

-- ── Move / indent selections ─────────────────────────────────
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

-- ── Paste / yank without clobbering ──────────────────────────
map("x", "p", [["_dP]], { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- ── Terminal ─────────────────────────────────────────────────
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Diagnostics ──────────────────────────────────────────────
map("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count =  1 }) end, { desc = "Next diagnostic" })

-- ── UI toggles ───────────────────────────────────────────────
map("n", "<leader>uw", function() vim.opt.wrap = not vim.o.wrap end, { desc = "Toggle wrap" })
map("n", "<leader>ur", function() vim.opt.relativenumber = not vim.o.relativenumber end, { desc = "Toggle relative number" })
map("n", "<leader>us", function() vim.opt.spell = not vim.o.spell end, { desc = "Toggle spell" })
map("n", "<leader>ud", function()
  local on = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not on)
  vim.notify((on and "Diagnostics off" or "Diagnostics on"), vim.log.levels.INFO, { title = "UI" })
end, { desc = "Toggle diagnostics" })

-- ── Lazy / Mason ─────────────────────────────────────────────
map("n", "<leader>L", "<cmd>Lazy<CR>",  { desc = "Lazy" })
map("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Mason" })
