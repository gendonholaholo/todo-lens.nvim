local Parser = require("todo_highlight.parser")

describe("parser", function()
  it("finds TODO items", function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      "-- TODO: refactor this",
      "print('hello')",
      "-- NOTE something else",
    })
    local items = Parser.parse_buffer(buf, {
      TODO = { priority = 10 },
      NOTE = { priority = 1 },
    })
    assert.are.equal(2, #items)
    assert.are.equal("TODO", items[1].keyword)
    assert.are.equal("NOTE", items[2].keyword)
  end)
end) 