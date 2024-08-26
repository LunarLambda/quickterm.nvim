local M = {}

local DEFAULT_OPTIONS = {
    position = 'bottom',
    size = 10
}

local SPLIT = {
    ["bottom"] = "horizontal botright",
    ["top"] = "horizontal topleft",
    ["left"] = "vertical topleft",
    ["right"] = "vertical botright",
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

function M.open()
    local did_open = false

    if not BUFFER then
        vim.cmd(SPLIT[OPTIONS.position] .. ' terminal')
        if OPTIONS.position == 'bottom' or OPTIONS.position == 'top' then
            vim.api.nvim_win_set_height(0, OPTIONS.size)
        else
            vim.api.nvim_win_set_width(0, OPTIONS.size)
        end
        BUFFER = vim.api.nvim_get_current_buf()
        vim.api.nvim_create_autocmd('BufDelete', {
            buffer = BUFFER,
            callback = function()
                BUFFER = nil
            end
        })
        did_open = true
    end

    if not M.is_open() then
        vim.cmd(SPLIT[OPTIONS.position] .. ' new')
        if OPTIONS.position == 'bottom' or OPTIONS.position == 'top' then
            vim.api.nvim_win_set_height(0, OPTIONS.size)
        else
            vim.api.nvim_win_set_width(0, OPTIONS.size)
        end
        vim.api.nvim_win_set_buf(0, BUFFER)
        did_open = true
    end

    if did_open and vim.fn.mode(0) ~= 't' then
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
