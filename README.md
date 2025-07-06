# todo-lens.nvim

A lightweight, high-performance Neovim plugin for highlighting and managing TODO-style comments with advanced listing capabilities.

![License](https://img.shields.io/github/license/gendonholaholo/todo-lens.nvim)
![Neovim version](https://img.shields.io/badge/Neovim-0.7%2B-blueviolet)
![Status](https://img.shields.io/badge/status-stable-green)

## Features

- **Blazing Fast**: < 5ms startup, < 10ms for 1000-line buffers
- **Real-time Highlighting**: Instant visual feedback as you type
- **Smart Navigation**: Quickfix list and Telescope integration
- **Optimized Performance**: Incremental updates and lazy loading
- **Highly Configurable**: Custom keywords, colors, and patterns
- **Low Overhead**: < 1MB memory usage for 50 open buffers
- **Robust Pattern Matching**: Uses Lua string patterns for maximum compatibility
- **Priority-based Sorting**: Organize TODOs by importance

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)
```lua
{
  "gendonholaholo/todo-lens.nvim",
  event = { "BufReadPost", "BufNewFile" },
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
    
    -- Optional keymaps
    vim.keymap.set("n", "<leader>tl", "<cmd>TodoList<CR>", { desc = "List TODOs" })
    vim.keymap.set("n", "<leader>tt", "<cmd>TodoToggle<CR>", { desc = "Toggle TODO highlighting" })
    vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use({
  "gendonholaholo/todo-lens.nvim",
  config = function()
    require("todo_lens").setup()
  end,
})
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'gendonholaholo/todo-lens.nvim'
```

### Local Development/Testing
```lua
{
  dir = "/path/to/your/todo-lens.nvim",
  name = "todo-lens.nvim",
  config = function()
    require("todo_lens").setup()
  end,
}
```

## Usage

### Commands
- `:TodoList` - Open quickfix window with all TODO items from open buffers
- `:TodoToggle` - Toggle comment highlighting on/off
- `:TodoTelescope` - Open fuzzy finder for TODO items (requires telescope.nvim)

### Default Keymaps
No default keymaps are set. Add your preferred mappings:

```lua
vim.keymap.set("n", "<leader>tl", "<cmd>TodoList<CR>", { desc = "List TODOs" })
vim.keymap.set("n", "<leader>tt", "<cmd>TodoToggle<CR>", { desc = "Toggle TODO highlighting" })
vim.keymap.set("n", "<leader>tf", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
```

## Configuration

### Full Configuration with Defaults
```lua
require("todo_lens").setup({
  keywords = {
    TODO  = { color = "TodoHighlightTODO",  priority = 10 },
    FIXME = { color = "TodoHighlightFIXME", priority = 10 },
    HACK  = { color = "TodoHighlightHACK",  priority = 5  },
    NOTE  = { color = "TodoHighlightNOTE",  priority = 1  },
  },
  colors = {
    TODO  = "#ff9e64",  -- Orange
    FIXME = "#e86671",  -- Red
    HACK  = "#bb9af7",  -- Purple
    NOTE  = "#7dcfff",  -- Blue
  },
  highlight = {
    keyword = "fg",        -- options: "fg" | "bg" | "none"
    after_keyword = "comment", -- highlight group for text after keyword
  },
})
```

### Custom Keywords and Colors
```lua
require("todo_lens").setup({
  keywords = {
    -- Using hex colors (automatically creates highlight groups)
    BUG   = { color = "#ff0000", priority = 20 },
    PERF  = { color = "#ffff00", priority = 15 },
    TEST  = { color = "#00ff00", priority = 5  },
    
    -- Using existing highlight groups
    WARN  = { color = "WarningMsg", priority = 12 },
    INFO  = { color = "Comment", priority = 3 },
  },
})
```

### Pattern Matching
The plugin detects TODO comments in various formats:
```lua
-- TODO: Basic format
-- FIXME without colon
-- NOTE:   with extra spaces
/* HACK: in block comments */
# TODO: in shell comments
<!-- FIXME: in HTML comments -->
```

## Advanced Features

### Telescope Integration
Requires [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim):
- Fuzzy search across all TODO items
- Live preview of TODO context
- Quick jump-to-definition
- Priority-based sorting

### Quickfix Integration
Standard Neovim quickfix list with:
- File path and location
- Keyword type and description
- Priority-based sorting
- Standard navigation (`<Enter>` to jump)

### Which-Key Integration
Optional integration with [which-key.nvim](https://github.com/folke/which-key.nvim):

```lua
-- Create separate file: lua/plugins/todo-lens-which-key.lua
return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.spec then
        opts.spec = {}
      end
      
      table.insert(opts.spec, {
        { "<leader>t", group = "TODO", icon = "󰗀" },
        { "<leader>tl", desc = "List TODOs", icon = "󰈙" },
        { "<leader>tt", desc = "Toggle TODO highlighting", icon = "󰸞" },
        { "<leader>tf", desc = "Find TODOs", icon = "󰍉" },
      })
      
      return opts
    end,
  },
}
```

## Performance

The plugin is optimized for performance:
- **Fast Startup**: Lazy loading with event-based initialization
- **Efficient Parsing**: Lua string patterns instead of complex regex
- **Incremental Updates**: Only processes changed content
- **Memory Conscious**: Minimal memory footprint
- **Debounced Processing**: Prevents excessive updates during rapid typing

## Troubleshooting

### Plugin Not Loading
1. Check `:Lazy` status (if using lazy.nvim)
2. Verify plugin path in configuration
3. Restart Neovim: `:Lazy reload todo-lens.nvim`

### No Highlighting Visible
1. Check if highlighting is enabled: `:TodoToggle`
2. Verify TODO comments exist in current buffer
3. Check error messages: `:messages`

### Commands Not Available
1. Verify plugin setup: `:lua print(vim.inspect(require("todo_lens")))`
2. Check for configuration errors
3. Ensure plugin loaded properly

### Which-Key Warnings
The plugin works without which-key. If you see warnings:
1. Remove which-key integration from plugin config
2. Use separate which-key configuration file (see above)
3. Check `:checkhealth which-key`

## Development

### Running Tests
```bash
# Install dependencies
make install

# Run tests
make test

# Format code
make format

# Check formatting
make lint

# Run all CI tasks
make ci
```

### Project Structure
```
├── lua/
│   ├── todo_highlight/          # Main plugin modules
│   │   ├── init.lua            # Plugin entry point
│   │   ├── config.lua          # Configuration management
│   │   ├── parser.lua          # TODO parsing logic
│   │   ├── highlighter.lua     # Highlighting functionality
│   │   ├── quickfix.lua        # Quickfix integration
│   │   └── telescope.lua       # Telescope integration
│   └── todo_lens/
│       └── init.lua            # Alias for backward compatibility
├── plugin/                     # Vim plugin files
├── tests/                      # Test suite
├── doc/                        # Documentation
└── .github/workflows/          # CI/CD
```

## Requirements

- **Neovim >= 0.7.0**
- **Optional**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for fuzzy finding
- **Optional**: [which-key.nvim](https://github.com/folke/which-key.nvim) for key descriptions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run `make ci` to ensure all checks pass
6. Submit a pull request

## License

MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by various TODO highlighting solutions in the Neovim ecosystem
- Built with Neovim's powerful Lua API
- Thanks to all contributors and testers

---

**Ready to try it out?** Clone the repository and follow the installation instructions above! 
