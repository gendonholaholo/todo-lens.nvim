local Config = require("todo_highlight.config")

describe("Config", function()
  before_each(function()
    -- Reset config state
    Config.setup()
  end)

  describe("setup", function()
    it("should use default configuration", function()
      Config.setup()
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.TODO)
      assert.is_not_nil(keywords.FIXME)
      assert.is_not_nil(keywords.HACK)
      assert.is_not_nil(keywords.NOTE)
    end)

    it("should merge user configuration", function()
      Config.setup({
        keywords = {
          CUSTOM = { color = "#ffffff", priority = 20 },
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.CUSTOM)
      assert.is_not_nil(keywords.TODO) -- should still have defaults
    end)

    it("should handle hex colors", function()
      Config.setup({
        keywords = {
          TEST = { color = "#ff0000", priority = 10 },
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.TEST)
      -- Color should be converted to highlight group name
      assert.is_string(keywords.TEST.color)
      assert.is_true(keywords.TEST.color:match("TodoHighlight"))
    end)

    it("should handle highlight group names", function()
      Config.setup({
        keywords = {
          TEST = { color = "Error", priority = 10 },
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.TEST)
      assert.are.equal("Error", keywords.TEST.color)
    end)
  end)

  describe("get", function()
    it("should return configuration values", function()
      Config.setup()
      local keywords = Config.get("keywords")
      local highlight = Config.get("highlight")
      assert.is_table(keywords)
      assert.is_table(highlight)
    end)

    it("should return nil for unknown keys", function()
      Config.setup()
      local unknown = Config.get("unknown_key")
      assert.is_nil(unknown)
    end)
  end)
end) 