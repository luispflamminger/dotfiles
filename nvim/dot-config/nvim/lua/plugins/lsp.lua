-- all plugins related to lsp setup

-- global state to keep track of whether we should format on the next save
vim.g.format_on_save = true
local function jdtls_config()
    local jdtls_mason_path = "/home/luisp/.local/share/nvim/mason/bin/jdtls"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local jdtls_cache_dir = "/home/luisp/.cache/jdtls/"
    local workspace_dir = jdtls_cache_dir .. "/workspace/" .. project_name
    local config_dir = jdtls_cache_dir .. "/config/"

    vim.api.nvim_create_autocmd('FileType', {
        pattern = "java",
        group = vim.api.nvim_create_augroup('JdtlsAttach', {}),
        callback = function(_)
            require("jdtls").start_or_attach({
                cmd = {
                    jdtls_mason_path,
                    "-configuration", config_dir,
                    "-data", workspace_dir,
                    "--jvm-arg=-javaagent:/home/luisp/.local/share/java/lombok.jar"
                },
                settings = {
                    java = {
                        saveActions = { organizeImports = true },
                        import = { exclusions = "target/*" },
                        sources = { organizeImports = { starThreshold = 5, staticStarThreshold = 3 } },
                    }
                },
                root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
            })

            -- organize imports
            vim.keymap.set('n', '<leader>co', function()
                vim.lsp.buf.code_action({
                    context = { only = { 'source.organizeImports' } },
                    apply = true,
                })
            end)
        end,
    })
end

local function nvim_lsp_config()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        -- i  have no idea what this does, but it configures the lua lsp to work with neovim
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if
                not vim.loop.fs_stat(path .. '/.luarc.json')
                and not vim.loop.fs_stat(path .. '/.luarc.jsonc')
            then
                client.config.settings =
                    vim.tbl_deep_extend('force', client.config.settings, {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true)
                            }
                        }
                    })
                client.notify(
                    "workspace/didChangeConfiguration",
                    { settings = client.config.settings }
                )
            end
            return true
        end
    })

    require('lspconfig').gopls.setup({})
    require('lspconfig').pylsp.setup({})
    require('lspconfig').marksman.setup({})
    require('lspconfig').lemminx.setup({})
end

-- keybinds
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(args)
        local buffer = args.buf

        -- Buffer local mappings.
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
        -- vim.keymap.set('n', 'C-k', vim.lsp.buf.signature_help)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end)

        -- setup for formatting modifications on save
        local augroup_id = vim.api.nvim_create_augroup(
            "FormatModificationsDocumentFormattingGroup",
            { clear = false }
        )
        -- local format_group_name = "FormatModificationsOnSave"
        vim.api.nvim_clear_autocmds({
            group = augroup_id,
            buffer = buffer
        })

        vim.keymap.set('n', '<space>df', function()
            vim.g.format_on_save = false
        end)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup(
                "FormatModificationsOnSave",
                { clear = false }
            ),
            buffer = buffer,
            callback = function()
                if vim.g.format_on_save == false then
                    return
                end

                -- format buffer on save
                for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = buffer })) do
                    local formatted = false

                    -- if the client supports document range formatting,
                    -- try to format only modified areas
                    if client.server_capabilities.documentRangeFormattingProvider then
                        local result = require("lsp-format-modifications")
                            .format_modifications(client, buffer)

                        if result.success then
                            formatted = true
                        end
                    end

                    -- if range formatting is not supported or failed, try to format the whole buffer
                    if formatted == false and client.server_capabilities.documentFormattingProvider then
                        vim.lsp.buf.format {
                            id = client.id,
                            bufnr = buffer,
                        }
                    end
                end

                vim.g.format_on_save = true
            end
        })
    end,
})

local function lint_config()
    require("lint").linters_by_ft = {
        go = { "golangcilint" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("LintOnSave", {}),
        callback = function()
            require("lint").try_lint()
        end,
    })
end

return {
    {
        "williamboman/mason.nvim",
        name = "mason",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        name = "mason-lspconfig",
        dependencies = { "mason" },
        opts = {
            ensure_installed = {
                "gopls",
                "marksman",
                "lemminx",
                "lua_ls",
                "pylsp",
                "jdtls",
            }
        },
    },
    {
        "joechrisellis/lsp-format-modifications.nvim",
        dependencies = {
            "plenary",
        },
    },
    {
        "neovim/nvim-lspconfig",
        name = "nvim-lspconfig",
        dependencies = { "mason-lspconfig" },
        config = nvim_lsp_config,
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "nvim-lspconfig" },
        lazy = true,
        ft = "java",
        config = jdtls_config,
    },
    {
        "mfussenegger/nvim-lint",
        config = lint_config,
    },
}
