local M = {}

---@param items table[]
function M.populate(items)
  local qf = {}
  for _, it in ipairs(items) do
    table.insert(qf, {
      bufnr = it.bufnr,
      lnum = it.lnum,
      col = it.col + 1, -- 1-based for quickfix
      text = string.format("%s: %s", it.keyword, it.text),
      type = "W", -- use Warning type for visibility
    })
  end
  vim.fn.setqflist(qf, "r")
  if #qf > 0 then
    vim.cmd("copen")
  else
    vim.notify("No TODO items found", vim.log.levels.INFO)
  end
end

return M 