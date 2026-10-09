require("mini.surround").setup({
    mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        suffix_last = "",
        suffix_next = "",
    },
    search_method = "cover_or_next",
})
vim.keymap.set("n", "yss", "ys_", { remap = true })
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
require("mini.pairs").setup({
    mappings = {
        ["<"] = { action = "open", pair = "<>" },
        [">"] = { action = "close", pair = "<>" },
    },
})
require("mini.cursorword").setup({})

require("mini.comment").setup({
    mappings = {
        comment_visual = "<leader>c",
    },
})
require("mini.move").setup({
    mappings = {
        left = "",
        right = "",
        down = "<A-j>",
        up = "<A-k>",
        line_left = "",
        line_right = "",
        line_down = "<A-j>",
        line_up = "<A-k>",
    },
})
