# 🧪 Manual Testing Guide - todo-lens.nvim

## 📋 Prerequisites
- Neovim >= 0.7.0
- Git installed
- Package manager: lazy.nvim, packer.nvim, or vim-plug

## 🚀 Manual Testing Steps

### Step 1: Clone Repository
```bash
# Clone to temporary directory for testing
cd /tmp
git clone https://github.com/gendonholaholo/todo-lens.nvim.git
cd todo-lens.nvim

# Verify all files are present
ls -la
```

**Expected files:**
- `README.md` - Comprehensive documentation
- `lua/todo_highlight/` - Main plugin modules
- `lua/todo_lens/init.lua` - Compatibility alias
- `plugin/` - Vim plugin entry points
- `tests/` - Test suite
- `doc/` - Documentation
- `.github/workflows/` - CI configuration

### Step 2: Test Plugin Installation

#### Option A: Using lazy.nvim
Add to your Neovim config:
```lua
{
  dir = "/tmp/todo-lens.nvim",
  name = "todo-lens.nvim",
  config = function()
    require("todo_lens").setup({
      keywords = {
        TODO  = { color = "#ff9e64", priority = 10 },
        FIXME = { color = "#e86671", priority = 10 },
        HACK  = { color = "#bb9af7", priority = 5  },
        NOTE  = { color = "#7dcfff", priority = 1  },
        BUG   = { color = "#f7768e", priority = 15 },
        PERF  = { color = "#9ece6a", priority = 8  },
      },
    })
    
    -- Test keymaps
    vim.keymap.set("n", "<leader>tl", "<cmd>TodoList<CR>", { desc = "List TODOs" })
    vim.keymap.set("n", "<leader>tt", "<cmd>TodoToggle<CR>", { desc = "Toggle TODO highlighting" })
    vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
  end,
}
```

#### Option B: Using GitHub URL
```lua
{
  "gendonholaholo/todo-lens.nvim",
  config = function()
    require("todo_lens").setup()
  end,
}
```

### Step 3: Create Test File
Create a test file with various TODO comments:

```bash
# Create test file in the cloned repository
cat > test_comprehensive.lua << 'EOF'
-- Comprehensive test file for todo-lens.nvim
local M = {}

-- TODO: Implement user authentication system
-- This should include login, logout, and session management
function M.auth_system()
  -- FIXME: Add proper input validation here
  -- Currently accepting any input without checks
  
  -- HACK: Temporary workaround for authentication
  -- Remove this once proper OAuth is implemented
  return true
end

-- BUG: Memory leak in data processing function
-- PERF: Optimize this algorithm for better performance
function M.process_data(data)
  local result = {}
  
  -- NOTE: This function processes user data
  -- Make sure to handle edge cases properly
  for i = 1, #data do
    -- TODO: Add error handling for invalid data
    table.insert(result, data[i] * 2)
  end
  
  return result
end

-- Different comment styles for testing
/* TODO: C-style block comment */
// FIXME: C-style line comment
# NOTE: Shell-style comment
<!-- HACK: HTML comment -->

-- Edge cases
-- TODO:Extra spaces and formatting
--TODO: No space after comment
-- TODO    : Weird spacing
-- TODO
-- FIXME: Multiple TODO items in same function
-- TODO: Another item right after

return M
EOF
```

### Step 4: Test Plugin Functionality

#### 4.1 Start Neovim and Load Plugin
```bash
nvim test_comprehensive.lua
```

#### 4.2 Verify Highlighting
**Expected Results:**
- `TODO` items highlighted in orange (#ff9e64)
- `FIXME` items highlighted in red (#e86671)
- `HACK` items highlighted in purple (#bb9af7)
- `NOTE` items highlighted in blue (#7dcfff)
- `BUG` items highlighted in pink (#f7768e)
- `PERF` items highlighted in green (#9ece6a)

#### 4.3 Test Commands

**Test `:TodoList`**
```vim
:TodoList
```
**Expected:** Quickfix window opens with ~12-15 TODO items listed

**Test `:TodoToggle`**
```vim
:TodoToggle
```
**Expected:** All highlighting disappears
```vim
:TodoToggle
```
**Expected:** Highlighting reappears

**Test `:TodoTelescope` (if telescope installed)**
```vim
:TodoTelescope
```
**Expected:** Telescope picker opens with fuzzy search

#### 4.4 Test Keymaps
- `<leader>tl` - Should open TodoList
- `<leader>tt` - Should toggle highlighting
- `<leader>tf` - Should open TodoTelescope

#### 4.5 Test Navigation
1. Open TodoList (`:TodoList`)
2. Use `j`/`k` to navigate items
3. Press `<Enter>` on any item
4. **Expected:** Jump to that TODO location

### Step 5: Test Edge Cases

#### 5.1 Test Different File Types
Create files with different extensions:
```bash
# JavaScript
echo "// TODO: Test JS comments" > test.js

# Python  
echo "# FIXME: Test Python comments" > test.py

# HTML
echo "<!-- NOTE: Test HTML comments -->" > test.html

# CSS
echo "/* HACK: Test CSS comments */" > test.css
```

Open each file and verify highlighting works.

#### 5.2 Test Large Files
```bash
# Create a large file with many TODOs
for i in {1..100}; do
  echo "-- TODO $i: Test item number $i" >> large_test.lua
done
```

Open and test performance:
```vim
:e large_test.lua
:TodoList
```

#### 5.3 Test Error Handling
```vim
" Test with invalid buffer
:lua require("todo_lens").highlight_buffer(9999)

" Check for errors
:messages
```
**Expected:** No errors, graceful handling

### Step 6: Test Configuration Options

#### 6.1 Test Custom Keywords
```vim
:lua require("todo_lens").setup({
  keywords = {
    CUSTOM = { color = "#ffffff", priority = 25 },
    TEST = { color = "Error", priority = 20 },
  }
})
```

Add `-- CUSTOM: test` and `-- TEST: test` to file, verify highlighting.

#### 6.2 Test Priority Sorting
Create file with mixed priorities:
```lua
-- NOTE: Low priority (1)
-- HACK: Medium priority (5)  
-- TODO: High priority (10)
-- BUG: Highest priority (15)
```

Run `:TodoList` and verify sorting by priority.

## ✅ Success Criteria

### Plugin Loading
- [ ] Plugin loads without errors
- [ ] No warning messages
- [ ] Commands available (`:command Todo`)

### Highlighting
- [ ] All 6 keyword types highlighted correctly
- [ ] Colors match configuration
- [ ] Works across different file types
- [ ] Toggle functionality works

### Navigation
- [ ] TodoList populates quickfix correctly
- [ ] All TODO items listed
- [ ] Navigation to items works
- [ ] Priority-based sorting

### Performance
- [ ] Fast startup (< 5ms)
- [ ] Smooth highlighting updates
- [ ] No lag with large files
- [ ] Memory usage reasonable

### Error Handling
- [ ] No crashes with invalid input
- [ ] Graceful degradation
- [ ] Clear error messages

## 🐛 Common Issues and Solutions

### Issue: Plugin not loading
**Solution:** Check `:Lazy` status, verify path, restart Neovim

### Issue: No highlighting
**Solution:** Check `:TodoToggle`, verify TODO comments exist, check `:messages`

### Issue: Commands not found
**Solution:** Verify plugin setup, check for config errors

### Issue: Performance problems
**Solution:** Check file size, verify incremental updates working

## 📊 Test Report Template

```
## Test Results - todo-lens.nvim

**Environment:**
- Neovim version: 
- OS: 
- Package manager: 

**Installation:** ✅/❌
**Highlighting:** ✅/❌  
**Commands:** ✅/❌
**Navigation:** ✅/❌
**Performance:** ✅/❌
**Error Handling:** ✅/❌

**Issues Found:**
- 

**Overall Status:** PASS/FAIL
```

---

**Ready to test?** Follow the steps above and report any issues! 🚀 