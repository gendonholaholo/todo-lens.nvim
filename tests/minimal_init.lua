-- Minimal init.lua for testing
local function add_pack(name)
  local install_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/" .. name
  if vim.fn.isdirectory(install_path) == 0 then
    return false
  end
  vim.opt.runtimepath:prepend(install_path)
  return true
end

-- Add current plugin to runtimepath
vim.opt.runtimepath:prepend(".")

-- Add test dependencies (optional)
local has_plenary = add_pack("plenary.nvim")
local has_telescope = add_pack("telescope.nvim")

-- Mock telescope if not available
if not has_telescope then
  package.loaded["telescope"] = {
    register_extension = function() end,
  }
  package.loaded["telescope.actions"] = {}
  package.loaded["telescope.actions.state"] = {}
  package.loaded["telescope.pickers"] = {}
  package.loaded["telescope.finders"] = {}
  package.loaded["telescope.config"] = { values = {} }
end

-- Disable swap files and backups for testing
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Set up basic configuration
vim.g.mapleader = " "
vim.opt.termguicolors = true

-- Ensure highlight groups exist for testing
vim.api.nvim_set_hl(0, "TodoHighlightTODO", { fg = "#ff9e64" })
vim.api.nvim_set_hl(0, "TodoHighlightFIXME", { fg = "#e86671" })
vim.api.nvim_set_hl(0, "TodoHighlightHACK", { fg = "#bb9af7" })
vim.api.nvim_set_hl(0, "TodoHighlightNOTE", { fg = "#7dcfff" })

-- Suppress startup messages
vim.opt.shortmess:append("I") 