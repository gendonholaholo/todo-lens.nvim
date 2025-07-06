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
  if type(keyword) ~= "string" or keyword == "" then
    return color
  end
  
  local hl_group = "TodoHighlight" .. keyword
  if type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
    -- It's a hex color, create highlight group
    local ok, _ = pcall(vim.api.nvim_set_hl, 0, hl_group, { fg = color })
    if ok then
      return hl_group
    end
  end
  return color
end

-- Validate and sanitize keyword configuration
local function validate_keyword(keyword, config)
  if type(keyword) ~= "string" or keyword == "" then
    return nil
  end
  
  if type(config) ~= "table" then
    return nil
  end
  
  return {
    color = config.color or "Todo",
    priority = type(config.priority) == "number" and config.priority or 5,
  }
end

function M.setup(user_cfg)
  -- Reset to defaults
  cfg = vim.deepcopy(defaults)
  
  if type(user_cfg) == "table" then
    cfg = vim.tbl_deep_extend("force", cfg, user_cfg)
  end

  -- Validate and setup keywords
  local validated_keywords = {}
  for kw, def in pairs(cfg.keywords or {}) do
    local validated = validate_keyword(kw, def)
    if validated then
      -- Setup highlight group
      validated.color = setup_highlight(kw, validated.color)
      validated_keywords[kw] = validated
    end
  end
  
  -- Ensure we have some keywords
  if next(validated_keywords) == nil then
    validated_keywords = vim.deepcopy(defaults.keywords)
  end
  
  cfg.keywords = validated_keywords

  -- Setup default colors if not overridden
  for kw, color in pairs(cfg.colors or {}) do
    if type(kw) == "string" and kw ~= "" and not cfg.keywords[kw] then
      cfg.keywords[kw] = {
        color = setup_highlight(kw, color),
        priority = 5,
      }
    end
  end
  
  -- Setup default highlight groups for existing keywords
  for kw, def in pairs(cfg.keywords) do
    if type(def.color) == "string" and def.color:match("^TodoHighlight") then
      -- Ensure the highlight group exists
      local default_color = defaults.colors[kw] or "#ffffff"
      pcall(vim.api.nvim_set_hl, 0, def.color, { fg = default_color })
    end
  end
end

function M.get(key)
  if type(key) ~= "string" then
    return nil
  end
  return cfg[key]
end

return M 