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
  -- Check for a valid 6-digit hex color string
  if type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
    local hl_group = "TodoHighlight" .. keyword
    -- Attempt to set the highlight group, but don't let it prevent returning the name
    pcall(vim.api.nvim_set_hl, 0, hl_group, { fg = color })
    -- The test expects the *name* of the group, so we must return it.
    return hl_group
  end

  -- For any other case (e.g., a pre-defined group name like "Error" or an invalid string),
  -- return the original value.
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

  -- Always process keywords first, converting colors to highlight groups if needed
  for kw, def in pairs(cfg.keywords or {}) do
    local validated = validate_keyword(kw, def)
    if validated then
      -- Always run through setup_highlight, even if color is from keywords
      validated.color = setup_highlight(kw, validated.color)
      validated_keywords[kw] = validated
    end
  end

  -- Add any keywords from colors table that are not already present
  for kw, color in pairs(cfg.colors or {}) do
    if type(kw) == "string" and kw ~= "" and not validated_keywords[kw] then
      validated_keywords[kw] = {
        color = setup_highlight(kw, color),
        priority = 5,
      }
    end
  end
  
  -- Ensure we have some keywords
  if next(validated_keywords) == nil then
    validated_keywords = vim.deepcopy(defaults.keywords)
  end
  
  cfg.keywords = validated_keywords

  -- Setup default highlight groups for existing keywords
  for kw, def in pairs(cfg.keywords) do
    if type(def.color) == "string" and def.color:match("^TodoHighlight") then
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