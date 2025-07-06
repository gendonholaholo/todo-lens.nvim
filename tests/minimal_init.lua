-- Minimal init.lua for testing
local function add_pack(name)
  -- Handle headless mode properly
  local data_path = vim.fn.has("nvim-0.8") == 1 and vim.fn.stdpath("data") or vim.fn.expand("~/.local/share/nvim")
  local install_path = data_path .. "/site/pack/deps/start/" .. name
  if vim.fn.isdirectory(install_path) == 0 then
    return false
  end
  vim.opt.runtimepath:prepend(install_path)
  return true
end

-- Add current plugin to runtimepath
vim.opt.runtimepath:prepend(".")

-- Add test dependencies (optional)
local has_plenary = pcall(add_pack, "plenary.nvim")
local has_telescope = pcall(add_pack, "telescope.nvim")

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
if vim.fn.has("gui_running") == 0 then
  vim.opt.termguicolors = true
end

-- Ensure highlight groups exist for testing
local function setup_highlights()
  local highlights = {
    TodoHighlightTODO = { fg = "#ff9e64" },
    TodoHighlightFIXME = { fg = "#e86671" },
    TodoHighlightHACK = { fg = "#bb9af7" },
    TodoHighlightNOTE = { fg = "#7dcfff" },
  }
  
  for group, opts in pairs(highlights) do
    pcall(vim.api.nvim_set_hl, 0, group, opts)
  end
end

setup_highlights()

-- Suppress startup messages
vim.opt.shortmess:append("I")

-- Ensure we have a proper test environment
if vim.fn.argc() == 0 then
  -- Create a test buffer if no arguments
  vim.cmd("enew")
end 