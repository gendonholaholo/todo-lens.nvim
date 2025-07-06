-- Minimal init.lua for testing
local function add_pack(name)
  local install_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/" .. name
  if vim.fn.isdirectory(install_path) == 0 then
    return
  end
  vim.opt.runtimepath:prepend(install_path)
end

-- Add current plugin to runtimepath
vim.opt.runtimepath:prepend(".")

-- Add test dependencies
add_pack("plenary.nvim")
add_pack("telescope.nvim")

-- Disable swap files and backups for testing
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Set up basic configuration
vim.g.mapleader = " "
vim.opt.termguicolors = true 