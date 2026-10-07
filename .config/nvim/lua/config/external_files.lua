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
