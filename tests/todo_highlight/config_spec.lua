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

    it("should handle invalid hex colors", function()
      Config.setup({
        keywords = {
          TEST = { color = "#invalid", priority = 10 },
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.TEST)
      -- Should still work, just not create highlight group
      assert.are.equal("#invalid", keywords.TEST.color)
    end)

    it("should handle missing priority", function()
      Config.setup({
        keywords = {
          TEST = { color = "#ff0000" },
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.TEST)
      -- Should have default priority or handle gracefully
      assert.is_not_nil(keywords.TEST.priority)
    end)

    it("should handle empty configuration", function()
      Config.setup({})
      local keywords = Config.get("keywords")
      -- Should still have defaults
      assert.is_not_nil(keywords.TODO)
    end)

    it("should handle nil configuration", function()
      Config.setup(nil)
      local keywords = Config.get("keywords")
      -- Should still have defaults
      assert.is_not_nil(keywords.TODO)
    end)

    it("should handle malformed keywords", function()
      Config.setup({
        keywords = {
          [""] = { color = "#ff0000", priority = 10 },
          [123] = { color = "#ff0000", priority = 10 },
        },
      })
      local keywords = Config.get("keywords")
      -- Should still have defaults
      assert.is_not_nil(keywords.TODO)
    end)

    it("should handle colors from colors table", function()
      Config.setup({
        colors = {
          CUSTOM = "#ff0000",
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.CUSTOM)
      assert.is_string(keywords.CUSTOM.color)
    end)

    it("should prioritize keywords over colors", function()
      Config.setup({
        keywords = {
          TEST = { color = "#ff0000", priority = 15 },
        },
        colors = {
          TEST = "#00ff00",
        },
      })
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords.TEST)
      assert.are.equal(15, keywords.TEST.priority)
      -- Color should be from keywords, not colors table
      assert.is_true(keywords.TEST.color:match("TodoHighlight"))
    end)
  end)

  describe("get", function()
    it("should return configuration values", function()
      Config.setup({
        keywords = {
          CUSTOM = { color = "#ff0000", priority = 20 },
        },
      })
      
      local keywords = Config.get("keywords")
      assert.is_not_nil(keywords)
      assert.is_not_nil(keywords.CUSTOM)
      
      local highlight = Config.get("highlight")
      assert.is_not_nil(highlight)
    end)

    it("should return nil for invalid keys", function()
      Config.setup()
      local invalid = Config.get("invalid_key")
      assert.is_nil(invalid)
    end)
  end)
end) 