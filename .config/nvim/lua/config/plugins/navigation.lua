require("neo-tree").setup({
    popup_border_style = "", -- Use the editor's ASCII winborder for dialogs.
    enable_git_status = true,
    enable_diagnostics = false,
    enable_modified_markers = false,
    default_component_configs = {
        indent = {
            indent_marker = "|",
            last_indent_marker = "+",
        },
        icon = {
            default = "",
            folder_closed = ">",
            folder_open = "v",
            folder_empty = ">",
            folder_empty_open = "v",
            provider = function(icon, node)
                if node.type == "file" then
                    icon.text = ""
                end
            end,
        },
        git_status = {
            symbols = {
                added = "A",
                modified = "M",
                deleted = "D",
                renamed = "R",
                untracked = "?",
                ignored = "I",
                unstaged = "M",
                staged = "A",
                conflict = "U",
            },
        },
    },
    window = {
        position = "left",
        width = 30,
    },
    filesystem = {
        bind_to_cwd = true,
        cwd_target = { sidebar = "tab", current = "window" },
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
        },
        follow_current_file = {
            enabled = true,
        },
    },
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
