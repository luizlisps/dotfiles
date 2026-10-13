vim.opt.termguicolors = true
require("mini.basics").setup()

require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
        globalstatus = false,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                function() return "λ" end,
                color = function()
                    return {
                        fg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Function", link = false }).fg),
                        gui = "bold",
                    }
                end,
                padding = { left = 1, right = 0 },
                separator = "",
            },
            "branch",
            { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
            {
                "diagnostics",
                symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
            },
        },
        lualine_c = {
            {
                "filename",
                path = 0,
                symbols = { modified = "[+]", readonly = "[RO]", unnamed = "[No Name]" },
            },
        },
        lualine_x = {
            "filetype",
            {
                "lsp_status",
                ignore_lsp = { "GitHub Copilot" },
                icon = "",
                symbols = {
                    spinner = { "-", "\\", "|", "/" },
                    done = "OK",
                    separator = " ",
                },
            },
            "selectioncount",
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "filetype", "location" },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { "quickfix", "man" },
})
local starter = require("mini.starter")
starter.setup({
    footer = "",
    content_hooks = {
        starter.gen_hook.adding_bullet("- "),
        starter.gen_hook.aligning("center", "center"),
    },
})
local bufferline = require("bufferline")
bufferline.setup({
    options = {
        mode = "buffers",
        style_preset = bufferline.style_preset.no_italic,
        indicator = { style = "none" },
        modified_icon = "+",
        buffer_close_icon = "",
        tab_size = 0,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = { "|", "|" },
        left_trunc_marker = "<",
        right_trunc_marker = "",
        show_buffer_icons = false,
    },
})
require("mini.notify").setup({
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
    window = {
        config = { title = "" },
    },
    -- pyright reports "Analyzing..." progress on every edit, which spams popups
    lsp_progress = { enable = false },
})
