local telescope = require("telescope.builtin")

local function map(lhs, rhs, description)
    vim.keymap.set("n", lhs, rhs, {
        silent = true,
        desc = description,
    })
end
local function current_buffer_directory()
    local filename = vim.api.nvim_buf_get_name(0)
    if filename == "" then
        return vim.fn.getcwd()
    end
    return vim.fn.fnamemodify(filename, ":p:h")
end

map("<leader>fc", function()
    telescope.find_files({ cwd = current_buffer_directory() })
end, "Files here")

map("<leader>e", "<cmd>Yazi<cr>", "Files")
map("<leader>gg", "<cmd>LazyGit<cr>", "Git UI")
map("<leader>ff", telescope.find_files, "Files")
map("<leader>fg", telescope.live_grep, "Search")
vim.keymap.set("x", "<leader>fg", telescope.grep_string, {
    silent = true,
    desc = "Search selected text",
})
map("<leader>fb", telescope.buffers, "Buffers")
map("<leader>bn", "<cmd>enew<cr>", "New buffer")
map("<leader>bd", "<cmd>bdelete<cr>", "Close buffer")
map("<leader>fh", telescope.help_tags, "Help tags")
map("<leader>dl", function()
    vim.diagnostic.open_float(0, { scope = "line" })
end, "Line diagnostic")
map("<leader>dd", function()
    telescope.diagnostics({ bufnr = 0 })
end, "Buffer diagnostics")
map("<leader>dw", telescope.diagnostics, "Workspace diagnostics")
map("<leader>l", "<cmd>Lint<cr>", "Lint")
map("gd", vim.lsp.buf.definition, "Go to definition")

map("<leader>fm", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, "Format buffer")
map("<leader>rr", "<cmd>Restart<cr>", "Restart Neovim")
map("<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

local function completion_navigation(forward)
    if vim.fn.pumvisible() == 1 then
        return forward and "<C-n>" or "<C-p>"
    end

    local direction = forward and 1 or -1
    if vim.snippet.active({ direction = direction }) then
        vim.snippet.jump(direction)
        return ""
    end

    return forward and "<Tab>" or "<S-Tab>"
end

vim.keymap.set({ "i", "s" }, "<Tab>", function()
    return completion_navigation(true)
end, { expr = true, replace_keycodes = true, silent = true, desc = "Next completion or snippet placeholder" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    return completion_navigation(false)
end, { expr = true, replace_keycodes = true, silent = true, desc = "Previous completion or snippet placeholder" })

local function accept_completion()
    local completion = vim.fn.complete_info({ "selected" })
    if vim.fn.pumvisible() == 1 and completion.selected >= 0 then
        return "<C-y>"
    end
    return "<CR>"
end

vim.keymap.set("i", "<CR>", accept_completion, {
    expr = true,
    replace_keycodes = true,
    silent = true,
    desc = "Accept completion",
})

vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
    silent = true,
    desc = "Trigger completion",
})
vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
    expr = true,
    replace_keycodes = false,
    silent = true,
    desc = "Accept Copilot suggestion",
})
map("<leader>ct", function()
    if vim.g.copilot_enabled == 0 then
        vim.cmd("Copilot enable")
    else
        vim.cmd("Copilot disable")
    end
end, "Toggle Copilot")
