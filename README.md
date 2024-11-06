# quickterm.nvim – Quick, reusable terminal buffers

Quickterm is a small Neovim plugin that allows you to quickly manipulate reusable terminal buffers.

## Setup

### lazy.nvim

`opts` shows default values.

```lua
{
    'LunarLambda/quickterm.nvim',
    opts = {
        -- Table of terminal names and their settings.
        terminals = {
            -- Settings for the default terminal. Used to fill in defaults for other terminals.
            default = {
                -- Position of the terminal ('left', 'right', 'top', 'bottom', 'tab')
                position = 'bottom',
                -- Width or height of the terminal. Ignored if position is set to 'tab'.
                -- Defaults to `min(lines / 2, 16)` for horizontal terminals,
                -- and `min(columns / 2, 64)` for vertical terminals.
                --
                -- Can be a function(position), in which case it is
                -- evaluated whenever the terminal is newly opened.
                size = 16,
                -- The command to execute in the terminal. Can be a string, list of strings,
                -- or a function returning one of the former, in which case
                -- it is evaluated whenever the terminal is newly opened.
                --
                -- Defaults to the current value of `{ vim.o.shell }`
                command = { vim.o.shell },
            }
        }
    },
    keys = {
        -- Example keybinding for a VS Code-like toggle mapping
        { '<C-`>', function() require('quickterm').toggle() end, mode = { 'n', 't' } },
    },
}
```

### Manual / init.lua

You will need to place the plugin in your `'runtimepath'`.

```lua
local quickterm = require 'quickterm'

quickterm.setup({
    -- Same contents as `opts` above
})

vim.keymap.set({ 'n', 't' }, '<C-`>', quickterm.toggle, { desc = 'Toggle terminal buffer' })
```

### API

`setup(opts)`: Initialize quickterm.nvim with the given `opts`.
See above for possible configuration options.

`current()`: Returns the name of the currently focused terminal.

`exists(term)`: Returns whether the terminal `term` exists,
and the id of the window it is visible in.

`get_options(term)`: Returns the configuration options for the terminal `term`.
If `term` doesn't exist, evaluate the configuration options for it, using defaults as necessary.

`open(term)`: Open (focus or create) the terminal `term`.
If `term` is omitted, open the default terminal.

`focus(term)`: Focus the terminal `term`.
If `term` is omitted, focus the default terminal.

`hide(term)`: Hide the terminal `term`.
If `term` is omitted, hide the currently focused terminal.

`close(term)`: Close the terminal `term`.
If `term` is omitted, close the currently focused terminal.

`toggle(term)`: Toggle (open or hide) the terminal `term`.
If `term` is omitted, toggle the default terminal.

## License

SPDX-License-Identifier: Apache-2.0 ([LICENSE.txt](LICENSE.txt))
