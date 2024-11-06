local api = vim.api

local window = require('quickterm.window')

local M = {}

M.buffers = {}

function M.create(name, opts)
   local buf = window.open(opts)

   vim.bo.bufhidden = 'hide'

   M.buffers[name] = { buf = buf, opts = opts }

   api.nvim_create_autocmd('BufDelete', {
      buffer = buf,
      callback = function()
         M.buffers[name] = nil
      end
   })

   vim.fn.termopen(opts.command)

   M.startinsert()

   return buf
end

function M.focus(t, win)
   if not t then
      return false
   end

   if win then -- we have a window, switch to it
      api.nvim_set_current_win(win)
   else -- open a window for the existing buffer
      window.open(t.opts)
      api.nvim_win_set_buf(0, t.buf)
   end

   M.startinsert()

   return true
end

function M.startinsert()
   if vim.fn.mode(0) ~= 't' then
      vim.cmd.startinsert()
   end
end

function M.current()
   for name, term in pairs(M.buffers) do
      if api.nvim_get_current_buf() == term.buf then
         return name
      end
   end

   return nil
end

function M.close(win, buf)
   if win then
      api.nvim_win_close(win, true)
   end

   if buf then
      api.nvim_buf_delete(buf, {})
   end

   return (win and buf) ~= nil
end

return M
