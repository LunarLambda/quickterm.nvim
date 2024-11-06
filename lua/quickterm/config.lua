local M = {}

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

function M.default_command()
   return { vim.o.shell }
end

function M.eval_options(opts)
   local size
   local command

   if opts.position ~= 'tab' and type(opts.size) == 'function' then
      size = opts.size(opts.position)
   else
      size = opts.size
   end

   if type(opts.command) == 'function' then
      command = opts.command()
   else
      command = opts.command
   end

   return {
      position = opts.position,
      size = size,
      command = command,
   }
end

M.DEFAULT_OPTIONS = {
   terminals = {
      default = {
         position = 'bottom',
         size = M.default_size,
         command = M.default_command,
      }
   }
}

return M
