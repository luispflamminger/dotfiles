-- all ai plugins
return {
    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                keymap = {
                    accept = "<S-tab>",
                    accept_word = false,
                    accept_line = false,
                    next = "<C-S-N>",
                    prev = "<C-S-P>",
                    dismiss = false,
                },
            },
            filetypes = {
                [""] = false,
                jproperties = false,
                markdown = true,
                gitcommit = true,
            },
        },
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false,
        opts = {
            provider = "openai",
            file_selector = {
                provider = "telescope",
            },
            hints = { enabled = false },
        },
        build = "make",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            -- "zbirenbaum/copilot.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
            "stevearc/dressing.nvim",
            "MunifTanjim/nui.nvim",
            "MeanderingProgrammer/render-markdown.nvim",
        },
    },
}
