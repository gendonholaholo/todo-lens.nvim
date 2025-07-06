-- Test file untuk todo-lens.nvim
local M = {}

-- TODO: Implement user authentication
function M.login(username, password)
  -- FIXME: Add input validation
  print("Logging in user: " .. username)
  
  -- HACK: Temporary hardcoded credentials
  if username == "admin" and password == "secret" then
    return true
  end
  
  -- NOTE: This should connect to database
  return false
end

-- TODO: Add error handling
-- FIXME: Memory leak in this function
function M.process_data(data)
  local result = {}
  
  -- HACK: Quick fix for performance
  for i = 1, #data do
    table.insert(result, data[i] * 2)
  end
  
  return result
end

-- NOTE: This is a utility function
function M.helper()
  -- TODO: Optimize this algorithm
  return "helper"
end

return M 