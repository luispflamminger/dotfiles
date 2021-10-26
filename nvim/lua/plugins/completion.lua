-- all plugins related to completion

local CMP_ELLIPSIS_CHAR = '…'
local CMP_ABBR_LENGTH = 25
local CMP_MENU_LENGTH = 40

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        init = function()
            -- max height of completion window
            vim.opt.pumheight = 15
        end,
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                view = { docs = { auto_open = true } },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    -- responsible for abbreviating entries so the window doesn't get too long
                    format = function(_, cmp_item)
                        if cmp_item.abbr ~= nil and string.len(cmp_item.abbr) > CMP_ABBR_LENGTH then
                            cmp_item.abbr = vim.fn.strcharpart(cmp_item.abbr, 0, CMP_ABBR_LENGTH) .. CMP_ELLIPSIS_CHAR
                        end
                        if cmp_item.menu ~= nil and string.len(cmp_item.menu) > CMP_MENU_LENGTH then
                            cmp_item.menu = vim.fn.strcharpart(cmp_item.menu, 0, CMP_MENU_LENGTH) .. CMP_ELLIPSIS_CHAR
                        end
                        return cmp_item
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    -- Accept currently selected item. Set `select` to `false`
                    -- to only confirm explicitly selected items.
                    ['<tab>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", group_index = 1 },
                    { name = "luasnip",  group_index = 1 },
                    { name = "buffer",   group_index = 1 },
                    { name = "path",     group_index = 1 },
                }),
            })

            -- cmp-commandline for completing "/" search from buffer
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                })
            })

            -- cmp-commandline for completing ":" commands
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    {
                        name = "cmdline",
                        option = { ignore_cmds = { "Man", "!" } },
                    },
                })
            })
        end,
    },
    {
        "saadparwaiz1/cmp_luasnip",
        dependencies = { "L3MON4D3/LuaSnip" },
    },
}
