local python_root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "uv.lock",
    ".git",
}

local function python_ruff(root_dir)
    if root_dir then
        local local_cmd = vim.fs.joinpath(root_dir, ".venv", "bin", "ruff")
        if vim.fn.executable(local_cmd) == 1 then
            return local_cmd
        end
    end

    return vim.fn.exepath("ruff")
end

vim.lsp.config["ruff"] = {
    cmd = function(dispatchers, config)
        local cmd = python_ruff(config.root_dir)
        if cmd == "" then
            vim.notify("ruff is not installed", vim.log.levels.ERROR)
            return
        end
        return vim.lsp.rpc.start({ cmd, "server" }, dispatchers)
    end,
    filetypes = { "python" },
    root_markers = python_root_markers,
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(args)
        local root_dir = vim.fs.root(args.buf, python_root_markers)
        if python_ruff(root_dir) ~= "" then
            vim.lsp.enable("ruff")
        end
    end,
})

if vim.fn.executable("ruff") == 1 then
    vim.lsp.enable("ruff")
end

vim.lsp.config["pyright"] = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = python_root_markers,
}

if vim.fn.executable("pyright-langserver") == 1 then
    vim.lsp.enable("pyright")
end
