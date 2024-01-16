return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "plenary" },
        tag = "0.1.5",
        config = function()
            require("telescope").setup()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fp', builtin.git_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },
}
