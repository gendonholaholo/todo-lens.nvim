local Config = require("todo_highlight.config")
local Parser = require("todo_highlight.parser")
local Highlighter = require("todo_highlight.highlighter")
local QF = require("todo_highlight.quickfix")

local M = {}
local ns = vim.api.nvim_create_namespace("todo_highlight")

-- Public -------------------------------------------------------------------
function M.setup(user_cfg)
  Config.setup(user_cfg)
  M._setup_autocmds()
end

function M.toggle()
  Highlighter.toggle()
end

function M.list()
  local aggregate = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local items = Parser.parse_buffer(buf, Config.get("keywords"))
    vim.list_extend(aggregate, items)
  end
  QF.populate(aggregate)
end

-- Private ------------------------------------------------------------------
function M._setup_autocmds()
  local aug = vim.api.nvim_create_augroup("TodoHighlight", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = aug,
    callback = function(evt)
      M.highlight_buffer(evt.buf)
    end,
  })
end

function M.highlight_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end
  local items = Parser.parse_buffer(bufnr, Config.get("keywords"))
  Highlighter.apply(bufnr, ns, items)
end

-- User commands -------------------------------------------------------------
vim.api.nvim_create_user_command("TodoToggle", function()
  M.toggle()
end, {})

vim.api.nvim_create_user_command("TodoList", function()
  M.list()
end, {})

return M 