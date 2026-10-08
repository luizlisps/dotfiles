vim.opt.termguicolors = true

require("mini.icons").setup({
    style = "glyph",
})
local mini_icons = require("mini.icons")
local function filetype_icon()
    local filetype = vim.bo.filetype
    if filetype == "" then
        return ""
    end
    return mini_icons.get("filetype", filetype)
end
local function filetype_icon_color()
    local filetype = vim.bo.filetype
    if filetype == "" then
        return nil
    end
    local _, highlight = mini_icons.get("filetype", filetype)
    return highlight
end

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
            {
                filetype_icon,
                color = filetype_icon_color,
            },
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
        lualine_x = {
            {
                filetype_icon,
                color = filetype_icon_color,
            },
            "location",
        },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { "neo-tree", "quickfix", "man" },
})
local bufferline = require("bufferline")
bufferline.setup({
    options = {
        mode = "buffers",
        style_preset = bufferline.style_preset.no_italic,
        indicator = { style = "icon", icon = ">" },
        modified_icon = "+",
        buffer_close_icon = "",
        tab_size = 0,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = { "|", "|" },
        left_trunc_marker = "<",
        right_trunc_marker = ">",
        get_element_icon = function(element)
            if element.path ~= "" then
                return (mini_icons.get("file", element.path))
            end
            if element.filetype ~= "" then
                return (mini_icons.get("filetype", element.filetype))
            end
        end,
    },
})
