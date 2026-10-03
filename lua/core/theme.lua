--  Theme toggler with persistence.
--  Pick a theme with <leader>uc — the choice survives restarts.

local M = {}

local DEFAULT = "cyberdream"
local statefile = vim.fn.stdpath("data") .. "/colorscheme"

---Read the saved colorscheme name, if any.
function M.saved()
  local f = io.open(statefile, "r")
  if not f then return nil end
  local name = vim.trim(f:read("*l") or "")
  f:close()
  return name ~= "" and name or nil
end

---Persist a colorscheme name for the next session.
function M.save(name)
  local f = io.open(statefile, "w")
  if not f then return end
  f:write(name)
  f:close()
end

---Apply the saved (or default) colorscheme, falling back gracefully.
function M.load()
  local name = M.saved() or DEFAULT
  if not pcall(vim.cmd.colorscheme, name) then
    pcall(vim.cmd.colorscheme, DEFAULT)
  end

  -- Remember whatever is picked from here on.
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("hisato_theme_persist", { clear = true }),
    callback = function(ev)
      M.save(ev.match)
      M.tweak()
    end,
  })
  M.tweak()
end

---Shared cosmetic touches applied on top of every theme.
function M.tweak()
  local set = vim.api.nvim_set_hl
  -- Make floating windows read as one surface with their border.
  set(0, "FloatBorder", { link = "NormalFloat", force = true })
  set(0, "NormalFloat", { link = "NormalFloat" })
  -- Softer, non-shouting indent guides.
  set(0, "WinSeparator", { link = "Comment", force = true })
end

return M
