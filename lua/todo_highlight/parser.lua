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
    local search_start = 1
    local line_matches = {}

    -- Step 1: Find all potential matches and their positions first.
    while true do
      local best_match = nil
      for _, keyword in ipairs(sorted_keywords) do
        local start_pos, end_pos = line:find(keyword, search_start, true) -- plain find
        if start_pos then
          -- Check boundaries manually
          local char_before = start_pos == 1 and " " or line:sub(start_pos - 1, start_pos - 1)
          local char_after = end_pos == #line and " " or line:sub(end_pos + 1, end_pos + 1)

          if not char_before:match("%w") and not char_after:match("%w") then
            -- This is a valid whole-word match. See if it's the earliest one.
            if not best_match or start_pos < best_match.start_pos then
              best_match = {
                keyword = keyword,
                start_pos = start_pos,
                end_pos = end_pos,
              }
            end
          end
        end
      end

      if best_match then
        table.insert(line_matches, best_match)
        search_start = best_match.end_pos + 1
      else
        break -- No more matches found on this line
      end
    end

    -- Step 2: Process the collected matches to extract descriptions correctly.
    for i, match in ipairs(line_matches) do
      local text_end_pos
      if i < #line_matches then
        text_end_pos = line_matches[i + 1].start_pos - 1
      else
        text_end_pos = #line
      end

      local text_start_pos = match.end_pos + 1
      local after_keyword = line:sub(text_start_pos, text_end_pos)
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