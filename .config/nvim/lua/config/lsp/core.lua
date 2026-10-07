vim.lsp.config["lua_ls"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        { ".luarc.json", ".luarc.jsonc" },
        ".git",
    },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
}

local php_root_markers = {
    "composer.json",
    "artisan",
    ".git",
}

vim.lsp.config["intelephense"] = {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php" },
    root_markers = php_root_markers,
    settings = {
        intelephense = {
            environment = {
                phpVersion = "8.3.0",
                includePaths = { "vendor" },
            },
        },
    },
}

if vim.fn.executable("intelephense") == 1 then
    vim.lsp.enable("intelephense")
end
