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
