local opt = vim.opt

opt.termguicolors = true

local function system_background()
    if vim.fn.has("macunix") == 1 or vim.fn.has("mac") == 1 then
        local style = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
        if style:lower():match("dark") then
            return "dark"
        end
    end

    return "light"
end

local switcher_dir = vim.fn.stdpath("config"):gsub("/nvim$", "") .. "/theme-switcher"
local active_theme_lines = vim.fn.readfile(switcher_dir .. "/current", "", 1)
local active_theme_id = active_theme_lines[1] or "solarized"
local themes = dofile(switcher_dir .. "/themes.lua")
local theme = assert(themes[active_theme_id], "Unknown theme: " .. active_theme_id)
local background

local function apply_theme(next_background)
    if next_background == background then
        return
    end

    background = next_background
    opt.background = background
    vim.cmd.colorscheme(theme.colorscheme)

    local palette = theme.palette[background]
    local warning = palette.warning
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
    local tabline_highlights = {
        MiniTablineCurrent = {
            fg = warning.text,
            bg = telescope_palette.selection,
            bold = true,
        },
        MiniTablineVisible = {
            fg = telescope_palette.results,
            bg = telescope_palette.surface,
        },
        MiniTablineHidden = {
            fg = telescope_palette.text,
            bg = telescope_palette.surface,
        },
        MiniTablineModifiedCurrent = {
            fg = telescope_palette.prompt,
            bg = telescope_palette.selection,
            bold = true,
        },
        MiniTablineModifiedVisible = {
            fg = telescope_palette.preview,
            bg = telescope_palette.surface,
            bold = true,
        },
        MiniTablineModifiedHidden = {
            fg = telescope_palette.preview,
            bg = telescope_palette.surface,
        },
        MiniTablineFill = { bg = telescope_palette.surface },
        MiniTablineTabpagesection = {
            fg = telescope_palette.border,
            bg = telescope_palette.surface,
            bold = true,
        },
        MiniTablineTrunc = {
            fg = telescope_palette.border,
            bg = telescope_palette.surface,
        },
    }

    for group, highlights in pairs(tabline_highlights) do
        vim.api.nvim_set_hl(0, group, highlights)
    end
end

local function refresh_system_theme()
    apply_theme(system_background())
end

refresh_system_theme()
vim.api.nvim_create_autocmd("FocusGained", { callback = refresh_system_theme })

local preferences_dir = vim.fn.expand("~/Library/Preferences")
if vim.fn.isdirectory(preferences_dir) == 1 then
    local watcher = vim.uv.new_fs_event()
    local started = watcher:start(preferences_dir, {}, function(err, filename)
        if not err and (filename == nil or filename == ".GlobalPreferences.plist") then
            vim.schedule(refresh_system_theme)
        end
    end)

    if started then
        vim.api.nvim_create_autocmd("VimLeavePre", {
            once = true,
            callback = function()
                watcher:stop()
                watcher:close()
            end,
        })
    else
        watcher:close()
    end
end
