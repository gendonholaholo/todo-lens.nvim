local M = {}

---@param keywords table<string, any>
local function build_pattern(keywords)
  local keys = vim.tbl_keys(keywords)
  table.sort(keys, function(a, b)
    return #a > #b -- longest first to prefer longer matches
  end)
  local joined = table.concat(keys, "|")
  -- match keyword followed by optional : or space, capture description
  return string.format([[\v<(?:%s)[: ]\s*(.*)]], joined)
end

---@param bufnr integer
---@param keywords table<string, {priority:number}>
---@return table[]
function M.parse_buffer(bufnr, keywords)
  local pattern = build_pattern(keywords)
  local regex = vim.regex(pattern)
  local items = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for idx, line in ipairs(lines) do
    local s, e = regex:match_str(line)
    if s then
      local keyword = line:sub(s + 1, e)
      local desc = vim.trim(line:sub(e + 2))
      table.insert(items, {
        bufnr = bufnr,
        lnum = idx,
        col = s,
        keyword = keyword,
        text = desc,
        priority = keywords[keyword] and keywords[keyword].priority or 0,
      })
    end
  end
  table.sort(items, function(a, b)
    if a.priority == b.priority then
      if a.bufnr == b.bufnr then
        return a.lnum < b.lnum
      end
      return a.bufnr < b.bufnr
    end
    return a.priority > b.priority
  end)
  return items
end

return M 