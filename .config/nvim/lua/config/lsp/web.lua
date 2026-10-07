local typescript_global_lib = ""
if vim.fn.executable("npm") == 1 then
    local npm_root = vim.fn.trim(vim.fn.system({ "npm", "root", "--global" }))
    if npm_root ~= "" then
        typescript_global_lib = npm_root .. "/typescript/lib"
    end
end
local function typescript_sdk(root_dir)
    if root_dir then
        local local_sdk = vim.fs.joinpath(root_dir, "node_modules", "typescript", "lib")
        if vim.uv.fs_stat(local_sdk) then
            return local_sdk
        end
    end

    return typescript_global_lib
end

vim.lsp.config["astro"] = {
    cmd = function(dispatchers, config)
        local cmd = "astro-ls"
        if config and config.root_dir then
            local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules", ".bin", cmd)
            if vim.fn.executable(local_cmd) == 1 then
                cmd = local_cmd
            end
        end
        return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
    end,
    filetypes = { "astro" },
    root_markers = {
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
        ".git",
    },
    init_options = {
        typescript = {},
    },
    before_init = function(_, config)
        local tsdk = typescript_sdk(config.root_dir)
        if tsdk ~= "" then
            config.init_options.typescript.tsdk = tsdk
        end
    end,
}

local typescript_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
}
local function typescript_language_server(root_dir)
    if root_dir then
        local local_cmd = vim.fs.joinpath(root_dir, "node_modules", ".bin", "typescript-language-server")
        if vim.fn.executable(local_cmd) == 1 then
            return local_cmd
        end
    end

    return vim.fn.exepath("typescript-language-server")
end

vim.lsp.config["ts_ls"] = {
    cmd = function(dispatchers, config)
        local cmd = typescript_language_server(config.root_dir)
        if cmd == "" then
            vim.notify("typescript-language-server is not installed", vim.log.levels.ERROR)
            return
        end
        return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
    end,
    filetypes = typescript_filetypes,
    root_markers = {
        { "tsconfig.json", "jsconfig.json" },
        "package.json",
        ".git",
    },
    init_options = {
        hostInfo = "neovim",
        tsserver = {
            fallbackPath = typescript_global_lib,
        },
        preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsWithSnippetText = true,
            jsxAttributeCompletionStyle = "braces",
        },
    },
}

return function()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = typescript_filetypes,
        callback = function(args)
            local root_dir = vim.fs.root(args.buf, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
            if typescript_language_server(root_dir) ~= "" then
                vim.lsp.enable("ts_ls")
            end
        end,
    })
end
