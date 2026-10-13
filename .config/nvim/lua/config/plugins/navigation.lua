-- Files are browsed with Yazi in a float, so the explorer never becomes a
-- listed buffer and keeps the same keys and icons as Yazi in the shell.
require("yazi").setup({
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_border = { "+", "-", "+", "|", "+", "-", "+", "|" },
})

local telescope_actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        multi_icon = "*",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.9,
            height = 0.85,
            prompt_position = "top",
            preview_width = 0.55,
        },
        path_display = { "truncate" },
        dynamic_preview_title = true,
        results_title = " Results ",
        prompt_title = " Search ",
        preview_title = " Preview ",
        winblend = 0,
        borderchars = {
            "-",
            "|",
            "-",
            "|",
            "+",
            "+",
            "+",
            "+",
        },
        mappings = {
            i = {
                ["<C-j>"] = telescope_actions.move_selection_next,
                ["<C-k>"] = telescope_actions.move_selection_previous,
            },
            n = {
                ["j"] = telescope_actions.move_selection_next,
                ["k"] = telescope_actions.move_selection_previous,
            },
        },
    },
})
require("gitsigns").setup({
    signcolumn = false,
    numhl = true,
    linehl = false,
})
