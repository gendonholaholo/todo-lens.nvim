-- Alias loader for todo-lens.nvim → reuses implementation in todo_highlight
-- This allows seamless transition while codebase still lives under lua/todo_highlight/

local base = require("todo_highlight")

-- Metatable to lazily proxy submodule lookups, e.g. require('todo_lens.parser')
return setmetatable(base, {
  __index = function(_, key)
    return require("todo_highlight." .. key)
  end,
}) 