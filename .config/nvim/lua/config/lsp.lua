-- Language servers: lua, typescript/javascript, python, rust, php. Each is
-- enabled only when its binary exists.

local typescript_global_lib = ""
if vim.fn.executable("npm") == 1 then
    local npm_root = vim.fn.trim(vim.fn.system({ "npm", "root", "--global" }))
    if npm_root ~= "" then
        typescript_global_lib = npm_root .. "/typescript/lib"
    end
end

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

vim.api.nvim_create_autocmd("FileType", {
    pattern = typescript_filetypes,
    callback = function(args)
        local root_dir = vim.fs.root(args.buf, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
        if typescript_language_server(root_dir) ~= "" then
            vim.lsp.enable("ts_ls")
        end
    end,
})

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

local rust_analyzer = vim.fn.exepath("rust-analyzer")
if rust_analyzer == "" and vim.fn.executable("rustup") == 1 then
    rust_analyzer = vim.fn.trim(vim.fn.system("rustup which rust-analyzer"))
end

vim.lsp.config["rust_analyzer"] = {
    cmd = { rust_analyzer },
    filetypes = { "rust" },
    -- Tauri keeps this at src-tauri/Cargo.toml. Neovim searches upward
    -- from the Rust file, so the workspace root becomes src-tauri.
    root_markers = {
        "Cargo.toml",
        "rust-project.json",
    },
    workspace_required = true,
}

if rust_analyzer ~= "" and vim.fn.executable(rust_analyzer) == 1 then
    vim.lsp.enable("rust_analyzer")
end

if vim.fn.executable("lua-language-server") == 1 then
    vim.lsp.enable("lua_ls")
end

local function format_completion_item(item)
    local label_details = item.labelDetails or {}
    local label_detail = label_details.detail or ""
    local abbr = item.label

    if label_detail ~= "" then
        abbr = abbr .. " " .. label_detail
    end

    local menu = label_details.description or item.detail or ""

    return {
        abbr = abbr .. " ",
        menu = menu == "" and menu or " " .. menu,
    }
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-completion", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client:is_stopped() then
            return
        end

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
                convert = format_completion_item,
            })
        end
    end,
})
