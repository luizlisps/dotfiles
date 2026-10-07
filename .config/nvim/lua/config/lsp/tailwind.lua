local tailwind_root_markers = {
    { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts" },
    { "postcss.config.js", "postcss.config.cjs", "postcss.config.mjs" },
    "package.json",
    ".git",
}
local tailwind_filetypes = {
    "blade",
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "php",
    "typescript",
    "typescriptreact",
}

local function tailwind_language_server(root_dir)
    if root_dir then
        local local_cmd = vim.fs.joinpath(root_dir, "node_modules", ".bin", "tailwindcss-language-server")
        if vim.fn.executable(local_cmd) == 1 then
            return local_cmd
        end
    end

    return vim.fn.exepath("tailwindcss-language-server")
end

vim.lsp.config["tailwindcss"] = {
    cmd = function(dispatchers, config)
        local cmd = tailwind_language_server(config.root_dir)
        if cmd == "" then
            return
        end
        return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
    end,
    filetypes = tailwind_filetypes,
    root_markers = tailwind_root_markers,
    settings = {
        tailwindCSS = {
            includeLanguages = {
                blade = "html",
                php = "html",
            },
            classAttributes = { "class", "className", "ngClass", "class:list" },
        },
    },
}

if vim.fn.executable("tailwindcss-language-server") == 1 then
    vim.lsp.enable("tailwindcss")
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = tailwind_filetypes,
    callback = function(args)
        local root_dir = vim.fs.root(args.buf, tailwind_root_markers)
        if tailwind_language_server(root_dir) ~= "" then
            vim.lsp.enable("tailwindcss")
        end
    end,
})
