local M = {}

---@param bufnr integer
---@param keywords table<string, {priority:number}>
---@return table[]
function M.parse_buffer(bufnr, keywords)
  local items = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  -- Sort keywords by length (longest first) for better matching
  local sorted_keywords = {}
  for keyword, _ in pairs(keywords) do
    table.insert(sorted_keywords, keyword)
  end
  table.sort(sorted_keywords, function(a, b)
    return #a > #b
  end)
  
  for idx, line in ipairs(lines) do
    for _, keyword in ipairs(sorted_keywords) do
      -- Look for keyword with word boundaries
      local pattern = "%f[%w]" .. keyword .. "%f[%W]"
      local start_pos, end_pos = line:find(pattern)
      
      if start_pos then
        -- Extract description after keyword
        local after_keyword = line:sub(end_pos + 1)
        local desc = vim.trim(after_keyword:gsub("^%s*:?%s*", ""))
        
        table.insert(items, {
          bufnr = bufnr,
          lnum = idx,
          col = start_pos - 1, -- 0-based for highlighting
          keyword = keyword,
          text = desc,
          priority = keywords[keyword] and keywords[keyword].priority or 0,
        })
        
        -- Only match first keyword per line
        break
      end
    end
  end
  
  -- Sort by priority, then by buffer, then by line
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