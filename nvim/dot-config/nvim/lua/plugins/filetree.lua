return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- disable netrw
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- plugin configuration
            local opts = {
                renderer = { group_empty = true, },
            }

            -- configure
            require("nvim-tree").setup(opts)

            -- keybinds
            vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<cr>")
            vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<cr>")
            vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFindFile<cr>")
        end,
    },
}
