# quickterm.nvim – Quick, reusable terminal buffer

Quickterm is a tiny Neovim plugin that allows you to quickly toggle a reusable terminal buffer.

## Setup

### lazy.nvim

`opts` shows default values.

```lua
{
    'LunarLambda/quickterm.nvim',
    opts = {
        -- Position of the terminal (left, right, top, bottom)
        position = 'bottom',
        -- Size of the terminal (width or height depending on `position`)
        size = 16,
        -- Command to execute in the terminal buffer
        -- Takes a string or list of strings (:h jobstart())
        command = { vim.o.shell },
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

## License

SPDX-License-Identifier: Apache-2.0 ([LICENSE.txt](LICENSE.txt))
