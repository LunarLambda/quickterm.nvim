local api = vim.api

local config   = require('quickterm.config')
local terminal = require('quickterm.terminal')
local window   = require('quickterm.window')

-- Returns the terminal buffer identified by `term`
-- and the id of the window it is open in.
local function find(term)
   local t = terminal.buffers[term]

   if not t then
      return nil, nil
   end

   local windows, in_window

   if t.opts.position == 'tab' then
      windows = api.nvim_list_wins()
   else
      windows = api.nvim_tabpage_list_wins(0)
   end

   for _, win in ipairs(windows) do
      if api.nvim_win_get_buf(win) == t.buf then
         in_window = win
      end
   end

   return t, in_window
end

local M = {
   current = terminal.current,
}

-- Initialize quickterm.nvim with the given `opts`.
function M.setup(opts)
   terminal.buffers = {}
   M.options = vim.tbl_deep_extend('keep', opts or {}, config.DEFAULT_OPTIONS)
end

-- Returns whether the terminal `term` exists
-- and the id of the window it is open in.
function M.exists(term)
   local t, win = find(term)

   return t ~= nil, win
end

-- Return the options for a terminal `term`
--
-- If `term` doesn't exist, evaluate the config options for it, using defaults as necessary.
function M.get_options(term)
   local t = terminal.buffers[term]

   if t then
      return t.opts
   else
      local opts    = config.eval_options(M.options.terminals[term])
      local default = config.eval_options(M.options.terminals.default)

      return vim.tbl_extend('keep', opts, default)
   end
end

-- Open (focus or create) the terminal `term`.
--
-- If `term` is omitted, open the terminal 'default'.
function M.open(term)
   term = term or 'default'

   if M.focus(term) then
      return true
   end

   terminal.create(term, M.get_options(term))
end

-- Focus the terminal `term`.
--
-- If `term` is omitted, focus the terminal 'default'.
function M.focus(term)
   local t, win = M.is_open(term or 'default')

   return terminal.focus(t, win)
end

-- Hide the terminal `term`.
--
-- If `term` is omitted, hide the current terminal.
function M.hide(term)
   local _, win = M.is_open(term or M.current())

   return terminal.close(win, nil)
end

-- Close the terminal `term`.
--
-- If `term` is omitted, close the current terminal.
function M.close(term)
   local t, win = M.is_open(term or M.current())

   return terminal.close(win, t.buf)
end

-- Toggle the terminal `term`.
--
-- If `term` is omitted, toggle the terminal 'default'
function M.toggle(term)
   term = term or 'default'

   local t, win = find(term)

   if win then -- the terminal is open in a window, hide it
      api.nvim_win_close(win, true)
   elseif t then -- we have a buffer, focus it
      terminal.focus(t, nil)
   else -- create a new buffer
      terminal.create(term, M.get_options(term))
   end
end

return M
