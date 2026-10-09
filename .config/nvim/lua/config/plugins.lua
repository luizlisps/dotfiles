vim.g.copilot_no_tab_map = true

-- Keep LazyGit's floating modal in the same ASCII style as Telescope.
vim.g.lazygit_floating_window_scaling_factor = 0.9
vim.g.lazygit_floating_window_border_chars = { "-", "|", "-", "|", "+", "+", "+", "+" }

vim.pack.add({
    {
        src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
        name = "neo-tree",
        version = vim.version.range("3"),
    },
    {
        src = "https://github.com/MunifTanjim/nui.nvim",
        name = "nui",
    },
    {
        src = "https://github.com/nvim-lua/plenary.nvim",
        name = "plenary",
    },
    {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        name = "telescope",
    },
    {
        src = "https://github.com/kdheepak/lazygit.nvim",
        name = "lazygit",
    },
    {
        src = "https://github.com/mfussenegger/nvim-lint",
        name = "nvim-lint",
    },
    {
        src = "https://github.com/stevearc/conform.nvim",
        name = "conform",
    },
    {
        src = "https://github.com/lewis6991/gitsigns.nvim",
        name = "gitsigns",
    },
    {
        src = "https://github.com/echasnovski/mini.nvim",
        name = "mini",
    },
    {
        src = "https://github.com/nvim-lualine/lualine.nvim",
        name = "lualine",
    },
    {
        src = "https://github.com/akinsho/bufferline.nvim",
        name = "bufferline",
    },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
    },
    {
        src = "https://github.com/github/copilot.vim",
        name = "copilot",
    },
    {
        src = "https://github.com/3rd/image.nvim",
        name = "image",
    },
    {
        src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
        name = "render-markdown",
    },
    {
        src = "https://github.com/lervag/vimtex",
        name = "vimtex",
    },
})

require("config.plugins.navigation")
require("config.plugins.editing")
require("config.plugins.interface")
require("config.plugins.syntax_media")
