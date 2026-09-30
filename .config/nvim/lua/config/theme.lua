local opt = vim.opt

local function system_background()
    if vim.fn.has("macunix") == 1 or vim.fn.has("mac") == 1 then
        local style = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })

        if style:lower():match("dark") then
            return "dark"
        end
    end

    return "light"
end

opt.termguicolors = true

local background = system_background()
opt.background = background
local switcher_dir = vim.fn.stdpath("config"):gsub("/nvim$", "") .. "/theme-switcher"
local active_theme_lines = vim.fn.readfile(switcher_dir .. "/current", "", 1)
local active_theme_id = active_theme_lines[1] or "sunbather"
local themes = dofile(switcher_dir .. "/themes.lua")
local theme = assert(themes[active_theme_id], "Unknown theme: " .. active_theme_id)

vim.cmd.colorscheme(theme.colorscheme)
local palette = theme.palette[background]

local warning = palette.warning
if warning then
    for _, group in ipairs({
        "WarningMsg",
        "DiagnosticWarn",
        "DiagnosticSignWarn",
        "DiagnosticVirtualTextWarn",
        "DiffChange",
        "SyntasticWarningSign",
        "NeomakeWarningSign",
    }) do
        vim.api.nvim_set_hl(0, group, { fg = warning.fg })
    end

    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
        sp = warning.fg,
        undercurl = true,
    })
    vim.api.nvim_set_hl(0, "IncSearch", {
        bg = warning.bg,
        fg = warning.text,
    })
    vim.api.nvim_set_hl(0, "SyntasticWarning", {
        bg = warning.bg,
        fg = warning.text,
        bold = true,
    })
end

local telescope_palette = palette.telescope

local telescope_highlights = {
    TelescopeNormal = { bg = telescope_palette.surface, fg = telescope_palette.text },
    TelescopeBorder = { bg = telescope_palette.surface, fg = telescope_palette.border },
    TelescopePromptNormal = { bg = telescope_palette.surface, fg = telescope_palette.text },
    TelescopePromptBorder = { bg = telescope_palette.surface, fg = telescope_palette.prompt },
    TelescopePromptTitle = { bg = telescope_palette.surface, fg = telescope_palette.prompt, bold = true },
    TelescopeResultsNormal = { bg = telescope_palette.surface, fg = telescope_palette.text },
    TelescopeResultsBorder = { bg = telescope_palette.surface, fg = telescope_palette.results },
    TelescopeResultsTitle = { bg = telescope_palette.surface, fg = telescope_palette.results, bold = true },
    TelescopePreviewNormal = { bg = telescope_palette.surface, fg = telescope_palette.text },
    TelescopePreviewBorder = { bg = telescope_palette.surface, fg = telescope_palette.preview },
    TelescopePreviewTitle = { bg = telescope_palette.surface, fg = telescope_palette.preview, bold = true },
    TelescopeSelection = { bg = telescope_palette.selection, fg = telescope_palette.selection_text, bold = true },
    TelescopeSelectionCaret = {
        bg = telescope_palette.selection,
        fg = telescope_palette.prompt,
        bold = true,
    },
    TelescopeMatching = { fg = telescope_palette.prompt, bold = true },
    TelescopeMultiSelection = { fg = telescope_palette.preview, bold = true },
}

for group, highlights in pairs(telescope_highlights) do
    vim.api.nvim_set_hl(0, group, highlights)
end
