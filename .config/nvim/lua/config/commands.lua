local function reload_config()
    local config = vim.fn.fnameescape(vim.fn.stdpath("config") .. "/init.lua")
    vim.cmd("source " .. config)
    vim.notify("Neovim config reloaded", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Reload", reload_config, {
    desc = "Reload Neovim config",
    force = true,
})

local function restart_with_current_file()
    local file = vim.api.nvim_buf_get_name(0)
    local cursor = vim.api.nvim_win_get_cursor(0)

    if file == "" or vim.bo.buftype ~= "" or vim.fn.filereadable(file) == 0 then
        vim.cmd("restart")
        return
    end

    local restart_command = string.format(
        "restart lua local file = %q; vim.cmd({ cmd = 'edit', args = { file } }); pcall(vim.api.nvim_win_set_cursor, 0, { %d, %d })",
        file,
        cursor[1],
        cursor[2]
    )
    vim.cmd(restart_command)
end

vim.api.nvim_create_user_command("Restart", restart_with_current_file, {
    desc = "Restart Neovim",
    force = true,
})

vim.cmd([[cnoreabbrev <expr> restart getcmdtype() ==# ':' && getcmdline() ==# 'restart' ? 'Restart' : 'restart']])
