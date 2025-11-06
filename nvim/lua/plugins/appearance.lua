-- make spaces and tabs visible
vim.opt.list = true
vim.opt.listchars = "tab:→\\x20,space:·"

-- all theming related plugins
return {
    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('bamboo').setup {
                transparent = false,
            }
            require('bamboo').load()
        end,
    },
    --{
    --    "ellisonleao/gruvbox.nvim",
    --    priority = 1000,
    --    config = function()
    --        require("gruvbox").setup({
    --            transparent_mode = true,

    --        })
    --        vim.cmd.colorscheme("gruvbox")
    --    end,
    --},
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = {
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                    },
                },
            },
        },
    },
    {
        -- requires a patched font (https://github.com/ryanoasis/nerd-fonts)
        "nvim-tree/nvim-web-devicons",
        config = true
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "▏",
            },
            scope = { enabled = false },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
            file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "mdx", "Avante" },
    },
}
