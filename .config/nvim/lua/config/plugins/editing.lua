require("nvim-surround").setup({})
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
