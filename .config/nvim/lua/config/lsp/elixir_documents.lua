local elixir_ls = vim.fn.exepath("elixir-ls")
vim.lsp.config["elixirls"] = {
    cmd = { elixir_ls },
    filetypes = { "elixir", "eelixir", "heex" },
    root_markers = {
        "mix.exs",
    },
    commands = {
        ["editor.action.triggerParameterHints"] = function()
            vim.lsp.buf.signature_help()
        end,
    },
}

if elixir_ls ~= "" and vim.fn.executable(elixir_ls) == 1 then
    vim.lsp.enable("elixirls")
end

vim.lsp.config["marksman"] = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown" },
    root_markers = {
        ".marksman.toml",
        ".git",
    },
}

if vim.fn.executable("marksman") == 1 then
    vim.lsp.enable("marksman")
end

vim.lsp.config["texlab"] = {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_markers = {
        { ".latexmkrc", "latexmkrc", "texlab.toml", "main.tex", "Makefile" },
        ".git",
    },
    settings = {
        texlab = {
            build = {
                onSave = false,
            },
        },
    },
}

if vim.fn.executable("texlab") == 1 then
    vim.lsp.enable("texlab")
end
