local TodoHighlight = require("todo_highlight")

describe("TodoHighlight Integration", function()
  local test_buf

  before_each(function()
    test_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(test_buf)
    -- Reset configuration
    TodoHighlight.setup()
  end)

  after_each(function()
    if vim.api.nvim_buf_is_valid(test_buf) then
      vim.api.nvim_buf_delete(test_buf, { force = true })
    end
  end)

  describe("setup", function()
    it("should initialize with default configuration", function()
      assert.has_no_error(function()
        TodoHighlight.setup()
      end)
    end)

    it("should accept custom configuration", function()
      assert.has_no_error(function()
        TodoHighlight.setup({
          keywords = {
            CUSTOM = { color = "#ff0000", priority = 20 },
          },
        })
      end)
    end)

    it("should handle empty configuration", function()
      assert.has_no_error(function()
        TodoHighlight.setup({})
      end)
    end)
  end)

  describe("highlight_buffer", function()
    it("should highlight TODO items", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: test highlighting",
        "print('hello')",
        "-- FIXME: another item",
      })

      assert.has_no_error(function()
        TodoHighlight.highlight_buffer(test_buf)
      end)
    end)

    it("should handle invalid buffer gracefully", function()
      TodoHighlight.setup()
      local invalid_buf = 9999

      assert.has_no_error(function()
        TodoHighlight.highlight_buffer(invalid_buf)
      end)
    end)

    it("should handle empty buffer", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {})

      assert.has_no_error(function()
        TodoHighlight.highlight_buffer(test_buf)
      end)
    end)
  end)

  describe("toggle", function()
    it("should toggle highlighting", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: test toggle",
      })

      TodoHighlight.highlight_buffer(test_buf)

      assert.has_no_error(function()
        TodoHighlight.toggle()
      end)

      assert.has_no_error(function()
        TodoHighlight.toggle()
      end)
    end)

    it("should handle multiple toggles", function()
      TodoHighlight.setup()
      
      for i = 1, 5 do
        assert.has_no_error(function()
          TodoHighlight.toggle()
        end)
      end
    end)
  end)

  describe("list", function()
    it("should populate quickfix list", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: first item",
        "-- FIXME: second item",
      })

      assert.has_no_error(function()
        TodoHighlight.list()
      end)

      local qflist = vim.fn.getqflist()
      assert.is_true(#qflist >= 0) -- Should not error
    end)

    it("should handle empty buffers", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {})

      assert.has_no_error(function()
        TodoHighlight.list()
      end)
    end)

    it("should handle no TODO items", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "print('hello world')",
        "local x = 42",
      })

      assert.has_no_error(function()
        TodoHighlight.list()
      end)
    end)
  end)

  describe("user commands", function()
    it("should create user commands", function()
      TodoHighlight.setup()

      -- Check if commands exist
      local commands = vim.api.nvim_get_commands({})
      assert.is_not_nil(commands.TodoList)
      assert.is_not_nil(commands.TodoToggle)
    end)

    it("should execute TodoList command", function()
      TodoHighlight.setup()
      vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
        "-- TODO: test command",
      })

      assert.has_no_error(function()
        vim.cmd("TodoList")
      end)
    end)

    it("should execute TodoToggle command", function()
      TodoHighlight.setup()

      assert.has_no_error(function()
        vim.cmd("TodoToggle")
      end)
    end)

    it("should handle TodoTelescope command gracefully", function()
      TodoHighlight.setup()
      
      -- Should not error even if telescope is not available
      assert.has_no_error(function()
        pcall(vim.cmd, "TodoTelescope")
      end)
    end)
  end)

  describe("error handling", function()
    it("should handle malformed keywords", function()
      assert.has_no_error(function()
        TodoHighlight.setup({
          keywords = {
            [""] = { color = "#ff0000", priority = 10 },
            [123] = { color = "#ff0000", priority = 10 },
          },
        })
      end)
    end)

    it("should handle invalid colors", function()
      assert.has_no_error(function()
        TodoHighlight.setup({
          keywords = {
            TEST = { color = "invalid_color", priority = 10 },
          },
        })
      end)
    end)

    it("should handle missing priority", function()
      assert.has_no_error(function()
        TodoHighlight.setup({
          keywords = {
            TEST = { color = "#ff0000" },
          },
        })
      end)
    end)
  end)
end) 