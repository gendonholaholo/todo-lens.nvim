local M = {}
local enabled = true

---Apply highlights for given items
---@param bufnr integer
---@param ns integer
---@param items table[]
function M.apply(bufnr, ns, items)
  if not enabled then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  for _, item in ipairs(items) do
    local hl_group = "TodoHighlight" .. item.keyword
    -- Ensure group exists (linking handled in config)
    vim.api.nvim_buf_add_highlight(bufnr, ns, hl_group, item.lnum - 1, item.col, item.col + #item.keyword)
  end
end

function M.toggle()
  enabled = not enabled
  -- Trigger redraw by re-entering buffer event
  vim.cmd("doautocmd <nomodeline> BufEnter")
end

return M 