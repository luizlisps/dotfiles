require("config.lsp.core")
require("config.lsp.python")
local register_typescript_filetypes = require("config.lsp.web")
require("config.lsp.infrastructure")
require("config.lsp.elixir_documents")

if vim.fn.executable("lua-language-server") == 1 then
    vim.lsp.enable("lua_ls")
end

if vim.fn.executable("typescript-language-server") == 1 then
    vim.lsp.enable("ts_ls")
end

register_typescript_filetypes()
require("config.lsp.tailwind")
vim.lsp.enable("astro")
require("config.lsp.rust")
require("config.lsp.completion")
