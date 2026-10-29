local opt = vim.opt

-- Expose the current file name to terminal and tmux status bars.
opt.title = true
opt.titlestring = "%t"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

opt.fillchars = { eob = " " }

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.confirm = true
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect", "popup" }

opt.winborder = "rounded"
opt.pumborder = "rounded"
opt.timeoutlen = 300

opt.autoread = true

opt.laststatus = 2
opt.showmode = false
opt.showcmd = false

local group = vim.api.nvim_create_augroup("external-file-sync", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    group = group,
    command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShell", {
    group = group,
    callback = function(args)
        local bufnr = args.buf
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == "" then
            return
        end

        if vim.fn.filereadable(path) == 0 then
            vim.api.nvim_set_vvar("fcs_choice", "")
            if vim.b[bufnr].external_file_deleted then
                return
            end

            vim.b[bufnr].external_file_deleted = true
            vim.bo[bufnr].modified = true
            vim.notify(
                string.format("File deleted externally; buffer kept: %s", vim.fn.fnamemodify(path, ":~")),
                vim.log.levels.WARN
            )
            return
        end

        if vim.v.fcs_reason == "conflict" then
            vim.api.nvim_set_vvar("fcs_choice", "ask")
            vim.notify(
                string.format("External change conflicts with local edits: %s", vim.fn.fnamemodify(path, ":~")),
                vim.log.levels.WARN
            )
        else
            vim.api.nvim_set_vvar("fcs_choice", "edit")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function(args)
        vim.b[args.buf].external_file_deleted = nil
    end,
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
