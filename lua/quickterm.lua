local M = {}

local DEFAULT_OPTIONS = {
    position = 'bottom',
    size = 10
}

local SPLIT = {
    ["left"] = { "vertical topleft", vim.api.nvim_win_set_width },
    ["right"] = { "vertical botright", vim.api.nvim_win_set_width },
    ["top"] = { "horizontal topleft", vim.api.nvim_win_set_height },
    ["bottom"] = { "horizontal botright", vim.api.nvim_win_set_height },
}

local OPTIONS = nil
local BUFFER = nil

function M.setup(opts)
    opts = opts or {}
    OPTIONS = vim.tbl_extend('keep', opts, DEFAULT_OPTIONS)
end

function M.is_open()
    if not BUFFER then
        return false
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(win) == BUFFER then
            return win
        end
    end

    return false
end

local function open_window()
    local split, set_size = unpack(SPLIT[OPTIONS.position])

    vim.cmd('noautocmd ' .. split.. ' new')
    set_size(0, OPTIONS.size)
end

local function open_term(buf)
    open_window()

    BUFFER = buf or vim.api.nvim_get_current_buf()

    vim.api.nvim_create_autocmd('BufDelete', {
        buffer = BUFFER,
        callback = function()
            BUFFER = nil
        end
    })

    -- If we already had a buffer, show it, else create a new one.
    if buf then
        vim.api.nvim_win_set_buf(0, buf)
    else
        vim.fn.termopen({ vim.o.shell })
    end
end

function M.open()
    if M.is_open() then
        return
    end

    open_term(BUFFER)

    if vim.fn.mode(0) ~= 't' then
        vim.cmd.startinsert()
    end
end

function M.close()
    local win = M.is_open()

    if not win then
        return
    end

    vim.api.nvim_win_close(win, true)
end

function M.toggle()
    if M.is_open() then
        M.close()
    else
        M.open()
    end
end

return M
