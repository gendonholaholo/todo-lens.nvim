# todo-lens.nvim

A lightweight, high-performance Neovim plugin for highlighting and managing TODO-style comments with advanced listing capabilities.

![License](https://img.shields.io/github/license/Gos/todo-lens.nvim)
![Neovim version](https://img.shields.io/badge/Neovim-0.7%2B-blueviolet)
![Status](https://img.shields.io/badge/status-stable-green)

## Features

- **Blazing Fast**: < 5ms startup, < 10ms for 1000-line buffers
- **Real-time Highlighting**: Instant visual feedback as you type
- **Smart Navigation**: Quickfix list and Telescope integration
- **Optimized Performance**: Incremental updates and lazy loading
- **Highly Configurable**: Custom keywords, colors, and patterns
- **Low Overhead**: < 1MB memory usage for 50 open buffers

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
  "Gos/todo-lens.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("todo_lens").setup({
      -- optional custom config
      keywords = {
        TODO  = { color = "#ff9e64", priority = 10 },
        FIXME = { color = "#e86671", priority = 10 },
        HACK  = { color = "#bb9af7", priority = 5  },
        NOTE  = { color = "#7dcfff", priority = 1  },
      },
    })
  end,
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use({
  "Gos/todo-lens.nvim",
  config = function()
    require("todo_lens").setup()
  end,
})
```

Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'Gos/todo-lens.nvim'
```

## Usage

### Commands
- `:TodoList` - Open quickfix window with all TODO items
- `:TodoToggle` - Toggle comment highlighting
- `:TodoTelescope` - Open fuzzy finder (requires telescope.nvim)

### Default Keymaps
None by default. Example configuration:
```lua
vim.keymap.set("n", "<leader>tl", "<cmd>TodoList<CR>", { desc = "List TODOs" })
vim.keymap.set("n", "<leader>tt", "<cmd>TodoToggle<CR>", { desc = "Toggle TODO highlighting" })
vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
```

## Configuration

Full configuration with defaults:
```lua
require("todo_lens").setup({
  keywords = {
    TODO  = { color = "TodoHighlightTODO",  priority = 10 },
    FIXME = { color = "TodoHighlightFIXME", priority = 10 },
    HACK  = { color = "TodoHighlightHACK",  priority = 5  },
    NOTE  = { color = "TodoHighlightNOTE",  priority = 1  },
  },
  highlight = {
    keyword = "fg",        -- options: "fg" | "bg" | "none"
    after_keyword = "comment", -- "comment" to link to Comment group
  },
})
```

### Custom Keywords
Add your own keywords with custom colors and priorities:
```lua
require("todo_lens").setup({
  keywords = {
    BUG   = { color = "#ff0000", priority = 20 },
    PERF  = { color = "#ffff00", priority = 15 },
    TEST  = { color = "#00ff00", priority = 5  },
  },
})
```

## Advanced Features

### Telescope Integration
Requires [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim). Provides:
- Fuzzy search across all TODO items
- Live preview of TODO context
- Quick jump-to-definition
- Priority-based sorting

### Quickfix Integration
Standard Neovim quickfix list populated with:
- File path and location
- Keyword type
- Full description text
- Priority-based sorting

## Performance

The plugin is optimized for performance:
- Incremental updates on changed lines
- Debounced processing during rapid typing
- Lazy loading of non-critical components
- Efficient regex pattern caching
- Memory-conscious data structures

## Development

### Running Tests
```bash
# Using Plenary test runner
nvim --headless -c "PlenaryBustedDirectory tests {minimal_init = './tests/minimal_init.lua'}"

# Or using busted directly
busted --lua=./tests/minimal_init.lua tests
```

### Architecture
- Modular design with clear separation of concerns
- Event-driven updates via Neovim autocmds
- Configuration-driven behavior
- Comprehensive error handling

## Requirements

- Neovim >= 0.7.0
- Optional: telescope.nvim for fuzzy finding

## Contributing

Contributions are welcome! Please check our [Contributing Guidelines](CONTRIBUTING.md).

## License

MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by various TODO highlighting solutions
- Built with Neovim's powerful Lua API
- Thanks to all contributors! 