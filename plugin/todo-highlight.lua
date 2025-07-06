if vim.g.loaded_todo_highlight then
  return
end
vim.g.loaded_todo_highlight = true

-- Defer setup to VimEnter to avoid impacting startup time
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    require("todo_highlight").setup()
  end,
}) 