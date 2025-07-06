local M = {}

local defaults = {
  keywords = {
    TODO  = { color = "TodoHighlightTODO",  priority = 10 },
    FIXME = { color = "TodoHighlightFIXME", priority = 10 },
    HACK  = { color = "TodoHighlightHACK",  priority = 5  },
    NOTE  = { color = "TodoHighlightNOTE",  priority = 1  },
  },
  colors = {
    TODO  = "#ff9e64",
    FIXME = "#e86671",
    HACK  = "#bb9af7",
    NOTE  = "#7dcfff",
  },
  highlight = {
    keyword = "fg",        -- options: "fg" | "bg" | "none"
    after_keyword = "comment", -- "comment" to link to Comment group
  },
}

local cfg = vim.deepcopy(defaults)

-- Convert hex color to highlight group and set it up
local function setup_highlight(keyword, color)
  local hl_group = "TodoHighlight" .. keyword
  if color:match("^#%x%x%x%x%x%x$") then
    -- It's a hex color, create highlight group
    vim.api.nvim_set_hl(0, hl_group, { fg = color })
  else
    -- It's a highlight group name, link to it
    vim.api.nvim_set_hl(0, hl_group, { link = color })
  end
  return hl_group
end

function M.setup(user_cfg)
  if user_cfg then
    cfg = vim.tbl_deep_extend("force", cfg, user_cfg)
  end

  -- Setup highlight groups
  for kw, def in pairs(cfg.keywords) do
    -- If color is a hex value, create highlight group
    local color = def.color
    if type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
      def.color = setup_highlight(kw, color)
    else
      -- Ensure highlight group exists
      if vim.fn.hlID(def.color) == 0 then
        vim.api.nvim_set_hl(0, def.color, { link = "Todo" })
      end
    end
  end

  -- Setup default colors if not overridden
  for kw, color in pairs(cfg.colors) do
    if not cfg.keywords[kw] then
      cfg.keywords[kw] = {
        color = setup_highlight(kw, color),
        priority = 5,
      }
    end
  end
end

function M.get(key)
  return cfg[key]
end

return M 