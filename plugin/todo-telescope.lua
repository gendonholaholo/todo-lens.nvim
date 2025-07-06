if vim.g.loaded_todo_telescope then
  return
end
vim.g.loaded_todo_telescope = true

vim.api.nvim_create_user_command("TodoTelescope", function()
  local ok, picker = pcall(require, "todo_highlight.telescope")
  if ok and picker then
    picker.open()
  else
    vim.notify("todo-highlight.nvim: Telescope not found", vim.log.levels.ERROR)
  end
end, {}) 