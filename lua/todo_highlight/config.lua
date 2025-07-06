local M = {}

local defaults = {
  keywords = {
    TODO  = { color = "TodoHighlightTODO",  priority = 10 },
    FIXME = { color = "TodoHighlightFIXME", priority = 10 },
    HACK  = { color = "TodoHighlightHACK",  priority = 5  },
    NOTE  = { color = "TodoHighlightNOTE",  priority = 1  },
  },
  highlight = {
    keyword = "fg",        -- options: "fg" | "bg" | "none"
    after_keyword = "comment", -- "comment" to link to Comment group or custom group name
  },
}

local cfg = vim.deepcopy(defaults)

function M.setup(user_cfg)
  if user_cfg then
    cfg = vim.tbl_deep_extend("force", cfg, user_cfg)
  end
  -- Ensure highlight groups exist
  for kw, def in pairs(cfg.keywords) do
    if vim.fn.hlID(def.color) == 0 then
      vim.api.nvim_set_hl(0, def.color, { link = "Todo" })
    end
  end
end

function M.get(key)
  return cfg[key]
end

return M 