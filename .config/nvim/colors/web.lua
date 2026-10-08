local switcher_dir = vim.fn.stdpath("config"):gsub("/nvim$", "") .. "/theme-switcher"
local active_theme_lines = vim.fn.readfile(switcher_dir .. "/current", "", 1)
local active_theme_id = active_theme_lines[1] or "web"
local themes = dofile(switcher_dir .. "/themes.lua")
local theme = assert(themes[active_theme_id], "Unknown theme: " .. active_theme_id)
local palette = assert(theme.palette[vim.o.background], "Missing palette for " .. vim.o.background)
local colors = assert(palette.colors, "Missing editor colors for " .. vim.o.background)

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = theme.colorscheme

local highlights = {
    Normal = { fg = colors.text, bg = colors.background },
    NormalNC = { fg = colors.text, bg = colors.background },
    NormalFloat = { fg = colors.text, bg = colors.surface },
    FloatBorder = { fg = colors.border, bg = colors.surface },
    FloatTitle = { fg = colors.link, bg = colors.surface, bold = true },
    NonText = { fg = colors.muted },
    EndOfBuffer = { fg = colors.border },
    Whitespace = { fg = colors.border },
    LineNr = { fg = colors.muted, bg = colors.background },
    CursorLine = { bg = colors.surface },
    CursorLineNr = { fg = colors.link, bg = colors.surface, bold = true },
    SignColumn = { fg = colors.muted, bg = colors.background },
    ColorColumn = { bg = colors.surface },
    Folded = { fg = colors.muted, bg = colors.surface },
    FoldColumn = { fg = colors.muted, bg = colors.background },
    Visual = { fg = colors.text, bg = colors.selection },
    VisualNOS = { fg = colors.text, bg = colors.selection },
    Search = { fg = colors.text, bg = colors.selection },
    CurSearch = { fg = colors.background, bg = colors.link, bold = true },
    IncSearch = { fg = colors.text, bg = colors.selection, bold = true },
    Substitute = { fg = colors.background, bg = colors.active, bold = true },
    MatchParen = { fg = colors.link, bg = colors.selection, bold = true },
    Pmenu = { fg = colors.text, bg = colors.surface },
    PmenuSel = { fg = colors.text, bg = colors.selection, bold = true },
    PmenuSbar = { bg = colors.border },
    PmenuThumb = { bg = colors.muted },
    StatusLine = { fg = colors.text, bg = colors.surface },
    StatusLineNC = { fg = colors.muted, bg = colors.surface },
    WinSeparator = { fg = colors.border },
    VertSplit = { fg = colors.border },
    TabLine = { fg = colors.muted, bg = colors.surface },
    TabLineSel = { fg = colors.text, bg = colors.selection, bold = true },
    TabLineFill = { bg = colors.surface },
    Directory = { fg = colors.link },
    Title = { fg = colors.link, bold = true },
    WarningMsg = { fg = colors.warning, bold = true },
    ErrorMsg = { fg = colors.error, bold = true },
    MoreMsg = { fg = colors.success },
    Question = { fg = colors.link },
    Todo = { fg = colors.text, bg = colors.selection, bold = true },
    Error = { fg = colors.error, bold = true },
    Underlined = { fg = colors.link, underline = true },
    Comment = { fg = colors.muted, italic = true },
    Constant = { fg = colors.constant },
    String = { fg = colors.string },
    Character = { fg = colors.string },
    Number = { fg = colors.number },
    Boolean = { fg = colors.constant },
    Float = { fg = colors.number },
    Identifier = { fg = colors.variable },
    Function = { fg = colors.func, bold = true },
    Statement = { fg = colors.keyword, bold = true },
    Conditional = { fg = colors.keyword, bold = true },
    Repeat = { fg = colors.keyword, bold = true },
    Label = { fg = colors.keyword },
    Operator = { fg = colors.operator },
    Keyword = { fg = colors.keyword, bold = true },
    Exception = { fg = colors.error },
    PreProc = { fg = colors.visited },
    Include = { fg = colors.visited },
    Define = { fg = colors.visited },
    Macro = { fg = colors.visited },
    Type = { fg = colors.type },
    StorageClass = { fg = colors.type },
    Structure = { fg = colors.type },
    Typedef = { fg = colors.type },
    Special = { fg = colors.visited },
    Delimiter = { fg = colors.text },
    SpecialKey = { fg = colors.muted },
    DiagnosticError = { fg = colors.error },
    DiagnosticWarn = { fg = colors.warning },
    DiagnosticInfo = { fg = colors.link },
    DiagnosticHint = { fg = colors.type },
    DiagnosticUnderlineError = { sp = colors.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = colors.warning, undercurl = true },
    DiagnosticUnderlineInfo = { sp = colors.link, undercurl = true },
    DiagnosticUnderlineHint = { sp = colors.type, undercurl = true },
    DiffAdd = { fg = colors.success, bg = colors.surface },
    DiffChange = { fg = colors.warning, bg = colors.surface },
    DiffDelete = { fg = colors.error, bg = colors.surface },
    DiffText = { fg = colors.text, bg = colors.selection, bold = true },
    SpellBad = { sp = colors.error, undercurl = true },
    SpellCap = { sp = colors.link, undercurl = true },
    SpellLocal = { sp = colors.type, undercurl = true },
    SpellRare = { sp = colors.visited, undercurl = true },
}

for group, value in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, value)
end

local links = {
    ["@comment"] = "Comment",
    ["@string"] = "String",
    ["@string.documentation"] = "Comment",
    ["@character"] = "Character",
    ["@number"] = "Number",
    ["@boolean"] = "Boolean",
    ["@constant"] = "Constant",
    ["@constant.builtin"] = "Constant",
    ["@function"] = "Function",
    ["@function.call"] = "Function",
    ["@function.builtin"] = "Function",
    ["@keyword"] = "Keyword",
    ["@keyword.function"] = "Keyword",
    ["@keyword.return"] = "Keyword",
    ["@operator"] = "Operator",
    ["@type"] = "Type",
    ["@type.builtin"] = "Type",
    ["@variable"] = "Identifier",
    ["@variable.builtin"] = "Constant",
    ["@parameter"] = "Identifier",
    ["@property"] = "Identifier",
    ["@field"] = "Identifier",
    ["@punctuation"] = "Delimiter",
    ["@markup.link"] = "Underlined",
    ["@markup.link.url"] = "Underlined",
    ["@markup.heading"] = "Title",
}

for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
end
