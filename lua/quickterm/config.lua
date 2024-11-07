local M = {}

function M.default_terminal()
   return {
      position = 'bottom',
      size = M.default_size('bottom'),
      command = { vim.o.shell },
   }
end

function M.default_size(pos)
   if pos == 'top' or pos == 'bottom' then
      if vim.o.lines / 2 > 16 then
         return 16
      else
         return math.floor(vim.o.lines / 2)
      end
   else
      if vim.o.columns / 2 > 64 then
         return 64
      else
         return math.floor(vim.o.columns / 2)
      end
   end
end

function M.eval_options(opts)
   return type(opts) == 'function' and opts() or opts
end

M.DEFAULT_OPTIONS = {
   terminals = {
      default = M.default_terminal,
   }
}

return M
