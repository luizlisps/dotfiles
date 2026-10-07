vim.g.mapleader = " "
vim.g.maplocalleader = " "

local homebrew_bin = "/opt/homebrew/bin"
local path = vim.env.PATH or ""
if vim.fn.isdirectory(homebrew_bin) == 1 and not path:find(homebrew_bin, 1, true) then
    vim.env.PATH = homebrew_bin .. ":" .. path
end

require("config.plugins")
require("config.latex")
require("config.markdown")
require("config.theme")
require("config.options")
require("config.external_files")
require("config.commands")
require("config.keymaps")
require("config.lsp")
require("config.lint")
require("config.plugins.key_hints")
