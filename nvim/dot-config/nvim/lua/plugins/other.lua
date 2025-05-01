-- other plugins
return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 1000
        end,
        config = true
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").create_default_mappings()
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.cmd [[Lazy load markdown-preview.nvim]]
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "nvim-pack/nvim-spectre",
        config = function()
            require('spectre').setup()
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
}
