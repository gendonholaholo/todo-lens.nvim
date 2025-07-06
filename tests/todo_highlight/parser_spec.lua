local Parser = require("todo_highlight.parser")

describe("Parser", function()
  local test_buf

  before_each(function()
    test_buf = vim.api.nvim_create_buf(false, true)
  end)

  after_each(function()
    if vim.api.nvim_buf_is_valid(test_buf) then
      vim.api.nvim_buf_delete(test_buf, { force = true })
    end
  end)

  describe("parse_buffer", function()
    it("should find TODO items", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: refactor this function",
        "print('hello world')",
        "-- FIXME: handle edge case",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
        FIXME = { priority = 10 },
      })

      assert.are.equal(2, #items)
      -- Items should be sorted by priority (descending), then by line number
      assert.are.equal("TODO", items[1].keyword)
      assert.are.equal("refactor this function", items[1].text)
      assert.are.equal("FIXME", items[2].keyword)
      assert.are.equal("handle edge case", items[2].text)
    end)

    it("should handle different comment styles", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "// TODO: C-style comment",
        "# NOTE: Shell-style comment",
        "<!-- HACK: HTML comment -->",
        "/* FIXME: block comment */",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
        NOTE = { priority = 5 },
        HACK = { priority = 3 },
        FIXME = { priority = 10 },
      })

      assert.are.equal(4, #items)
      -- Should be sorted by priority (descending), then by line number
      -- Priority 10: TODO (line 1), FIXME (line 4)
      -- Priority 5: NOTE (line 2)
      -- Priority 3: HACK (line 3)
      assert.are.equal("TODO", items[1].keyword)
      assert.are.equal("FIXME", items[2].keyword)
      assert.are.equal("NOTE", items[3].keyword)
      assert.are.equal("HACK", items[4].keyword)
    end)

    it("should sort by priority", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- NOTE: low priority",
        "-- TODO: high priority",
        "-- HACK: medium priority",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
        HACK = { priority = 5 },
        NOTE = { priority = 1 },
      })

      assert.are.equal(3, #items)
      -- Should be sorted by priority (descending)
      assert.are.equal("TODO", items[1].keyword)
      assert.are.equal("HACK", items[2].keyword)
      assert.are.equal("NOTE", items[3].keyword)
    end)

    it("should handle colon and space separators", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: with colon",
        "-- FIXME without colon",
        "-- NOTE:   with colon and spaces",
        "-- HACK    with spaces only",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
        FIXME = { priority = 10 },
        NOTE = { priority = 5 },
        HACK = { priority = 3 },
      })

      assert.are.equal(4, #items)
      -- Check that text is extracted correctly
      local todo_item = nil
      local fixme_item = nil
      local note_item = nil
      local hack_item = nil
      
      for _, item in ipairs(items) do
        if item.keyword == "TODO" then
          todo_item = item
        elseif item.keyword == "FIXME" then
          fixme_item = item
        elseif item.keyword == "NOTE" then
          note_item = item
        elseif item.keyword == "HACK" then
          hack_item = item
        end
      end
      
      assert.is_not_nil(todo_item)
      assert.is_not_nil(fixme_item)
      assert.is_not_nil(note_item)
      assert.is_not_nil(hack_item)
      
      assert.are.equal("with colon", todo_item.text)
      assert.are.equal("without colon", fixme_item.text)
      assert.are.equal("with colon and spaces", note_item.text)
      assert.are.equal("with spaces only", hack_item.text)
    end)

    it("should handle empty buffer", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {})

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
      })

      assert.are.equal(0, #items)
    end)

    it("should handle buffer with no TODO items", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "print('hello world')",
        "local x = 42",
        "return x",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
      })

      assert.are.equal(0, #items)
    end)

    it("should handle case sensitivity", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: uppercase",
        "-- todo: lowercase",
        "-- Todo: mixed case",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
      })

      -- Should only match exact case
      assert.are.equal(1, #items)
      assert.are.equal("TODO", items[1].keyword)
      assert.are.equal("uppercase", items[1].text)
    end)

    it("should handle word boundaries", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: should match",
        "-- TODOFIX: should not match TODO",
        "-- MYTODO: should not match TODO",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
      })

      -- Should only match exact word boundaries
      assert.are.equal(1, #items)
      assert.are.equal("TODO", items[1].keyword)
      assert.are.equal("should match", items[1].text)
    end)

    it("should handle invalid buffer", function()
      local invalid_buf = 9999
      
      local items = Parser.parse_buffer(invalid_buf, {
        TODO = { priority = 10 },
      })

      assert.are.equal(0, #items)
    end)

    it("should handle multiple TODO items on same line", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: first item FIXME: second item",
      })

      local items = Parser.parse_buffer(test_buf, {
        TODO = { priority = 10 },
        FIXME = { priority = 10 },
      })

      -- Should find both items
      assert.are.equal(2, #items)
    end)

    it("should handle empty keywords config", function()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: should not match",
      })

      local items = Parser.parse_buffer(test_buf, {})

      assert.are.equal(0, #items)
    end)
  end)
end) 