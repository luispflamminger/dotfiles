-- make spaces and tabs visible
vim.opt.list = true
vim.opt.listchars = "tab:→\\x20,space:·"

-- all theming related plugins
return {
    -- {
    --     "folke/tokyonight.nvim",
    --     name = "tokyonight",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("tokyonight").setup({
    --             style = "moon"
    --         })
    --         vim.cmd.colorscheme("tokyonight")
    --     end,
    -- },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                transparent_mode = true,

            })
            vim.cmd.colorscheme("gruvbox")
        end,
    },
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
}
