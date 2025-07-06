local M = {}

---@param bufnr integer
---@param keywords table<string, {priority:number}>
---@return table[]
function M.parse_buffer(bufnr, keywords)
  -- Gracefully handle invalid buffer numbers (e.g. test passes 9999)
  if type(bufnr) ~= "number" or not vim.api.nvim_buf_is_valid(bufnr) then
    return {}
  end
  
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
    local line_items = {}
    local search_start = 1

    while true do
      local earliest_match = nil

      -- Find the keyword that appears earliest in the rest of the line
      for _, keyword in ipairs(sorted_keywords) do
        local pattern = "%f[%w]" .. keyword .. "%f[%W]"
        local start_pos, end_pos = line:find(pattern, search_start)

        if start_pos then
          if not earliest_match or start_pos < earliest_match.start_pos then
            earliest_match = {
              keyword = keyword,
              start_pos = start_pos,
              end_pos = end_pos,
            }
          end
        end
      end

      if earliest_match then
        table.insert(line_items, earliest_match)
        search_start = earliest_match.end_pos + 1
      else
        break -- No more matches on this line
      end
    end

    -- Now process the found items on the line to correctly extract descriptions
    for i, match in ipairs(line_items) do
      local text_end
      if i < #line_items then
        -- The description ends where the next keyword starts
        text_end = line_items[i + 1].start_pos - 1
      else
        -- It's the last keyword, description goes to end of line
        text_end = #line
      end

      local after_keyword = line:sub(match.end_pos + 1, text_end)
      local desc = vim.trim(after_keyword:gsub("^%s*:?%s*", ""))

      table.insert(items, {
        bufnr = bufnr,
        lnum = idx,
        col = match.start_pos - 1,
        keyword = match.keyword,
        text = desc,
        priority = keywords[match.keyword].priority or 0,
      })
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