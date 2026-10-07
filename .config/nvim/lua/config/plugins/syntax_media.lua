local treesitter_filetypes = {
    "astro",
    "bash",
    "blade",
    "css",
    "dockerfile",
    "eelixir",
    "elixir",
    "heex",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "php",
    "python",
    "rust",
    "tsx",
    "typescript",
    "typst",
    "vim",
    "vimdoc",
    "yaml",
}

require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})
require("nvim-treesitter").install({
    "astro",
    "bash",
    "blade",
    "css",
    "dockerfile",
    "eex",
    "elixir",
    "heex",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "php",
    "phpdoc",
    "python",
    "rust",
    "tsx",
    "typescript",
    "typst",
    "vim",
    "vimdoc",
    "yaml",
})
require("render-markdown").setup({
    render_modes = { "n", "c", "t" },
    latex = {
        enabled = false,
    },
    completions = {
        lsp = {
            enabled = true,
        },
    },
    heading = {
        sign = false,
        icons = { "H1 ", "H2 ", "H3 ", "H4 ", "H5 ", "H6 " },
        position = "inline",
        width = "block",
    },
    code = {
        sign = false,
        language_icon = false,
        language_info = false,
        width = "block",
        border = "thin",
        language_border = "-",
        above = "-",
        below = "-",
    },
    bullet = {
        icons = { "-", "*", "+" },
    },
    checkbox = {
        unchecked = {
            icon = "[ ]",
        },
        checked = {
            icon = "[x]",
        },
        custom = {
            todo = {
                rendered = "[-]",
            },
        },
    },
    quote = {
        icon = ">",
    },
    dash = {
        icon = "-",
    },
    pipe_table = {
        border = { "+", "+", "+", "+", "+", "+", "+", "+", "+", "|", "-" },
        alignment_indicator = "-",
    },
    link = {
        enabled = false,
    },
    win_options = {
        conceallevel = {
            default = 2,
            rendered = 3,
        },
        concealcursor = {
            default = "",
            rendered = "",
        },
    },
})
local treesitter_group = vim.api.nvim_create_augroup("treesitter-start", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = treesitter_group,
    pattern = treesitter_filetypes,
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        eelixir = { "mix" },
        elixir = { "mix" },
        heex = { "mix" },
        html = { "prettier" },
        json = { "prettier" },
        blade = { "blade-formatter" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_format" }
            end
            return {}
        end,
        php = { "pint" },
        yaml = { "prettier" },
    },
})
require("image").setup({
    backend = "kitty",
    processor = "magick_cli",
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
        },
    },
    max_width_window_percentage = 50,
    max_height_window_percentage = 50,
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.ico" },
})
