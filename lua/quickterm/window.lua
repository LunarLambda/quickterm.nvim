local api = vim.api

local M = {}

M.SPLITS = {
   ['left']   = { 'vertical topleft',    api.nvim_win_set_width  },
   ['right']  = { 'vertical botright',   api.nvim_win_set_width  },
   ['top']    = { 'horizontal topleft',  api.nvim_win_set_height },
   ['bottom'] = { 'horizontal botright', api.nvim_win_set_height },
   ['tab']    = { 'tab', function() end }
}

-- TODO: Make it use create_buf/create_window APIs.
-- This would allow more fanciful configuration.
function M.open(opts)
   local open_how, set_size = unpack(M.SPLITS[opts.position])

   vim.cmd('noautocmd ' .. open_how .. ' new')
   set_size(0, opts.size)

   return api.nvim_get_current_buf()
end

return M
