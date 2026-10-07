local telescope = require("telescope.builtin")

local function map(lhs, rhs, description)
    vim.keymap.set("n", lhs, rhs, {
        silent = true,
        desc = description,
    })
end
local function peek_documentation()
    vim.lsp.buf.hover()
end

local function peek_signature()
    vim.lsp.buf.signature_help()
end

local function show_leader_help()
    local leader = vim.g.mapleader or " "
    local leader_name = leader == " " and "<Space>" or leader

    telescope.keymaps({
        modes = { "n" },
        show_plug = false,
        lhs_filter = function(lhs)
            return lhs:sub(1, #leader) == leader or lhs:sub(1, #leader_name) == leader_name
        end,
        prompt_title = "Leader help",
        results_title = "Usage",
        previewer = false,
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.65,
            height = 0.6,
        },
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

map("<leader>e", "<cmd>Neotree filesystem focus left<cr>", "File tree")
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
map("[b", "<cmd>bprevious<cr>", "Previous buffer")
map("]b", "<cmd>bnext<cr>", "Next buffer")
map("<leader>fh", telescope.help_tags, "Help tags")
map("<leader>he", show_leader_help, "Leader help")
map("<leader>d", function()
    vim.diagnostic.open_float(0, { scope = "line" })
end, "Line diagnostic")
map("<leader>dd", function()
    telescope.diagnostics({ bufnr = 0 })
end, "Buffer diagnostics")
map("<leader>dw", telescope.diagnostics, "Workspace diagnostics")
map("<leader>l", "<cmd>Lint<cr>", "Lint")
map("gd", vim.lsp.buf.definition, "Go to definition")
map("K", peek_documentation, "Peek docs")
map("<leader>hd", peek_documentation, "Peek docs")
map("<leader>hs", peek_signature, "Peek signature")
map("<leader>pd", telescope.lsp_definitions, "Peek definition")
map("gI", vim.lsp.buf.implementation, "Go to implementation")
map("gr", vim.lsp.buf.references, "Find references")
map("grn", vim.lsp.buf.rename, "Rename symbol")

map("<leader>fm", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, "Format buffer")
map("<leader>rr", "<cmd>Restart<cr>", "Restart Neovim")
map("<leader>rc", "<cmd>Reload<cr>", "Reload config")
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
