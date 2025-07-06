local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local Parser = require("todo_highlight.parser")
local Config = require("todo_highlight.config")

local M = {}

function M.open()
  local aggregate = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local items = Parser.parse_buffer(buf, Config.get("keywords"))
    vim.list_extend(aggregate, items)
  end

  pickers.new({}, {
    prompt_title = "TODO Items",
    finder = finders.new_table({
      results = aggregate,
      entry_maker = function(item)
        return {
          value = item,
          display = string.format("%s:%d %s", vim.api.nvim_buf_get_name(item.bufnr), item.lnum, item.text),
          ordinal = item.keyword .. " " .. item.text,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map({ "<CR>", "<C-]>", "<C-s>" }, function(prompt_bufnr)
        local entry = actions_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        local itm = entry.value
        vim.api.nvim_set_current_buf(itm.bufnr)
        vim.api.nvim_win_set_cursor(0, { itm.lnum, itm.col })
      end)
      return true
    end,
  }):find()
end

return M 