-- all plugins related to lsp setup

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
                    }
                },
                root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
            })
        end,
    })
end

local function nvim_lsp_config()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- lua
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
                                -- library = {
                                --     vim.env.VIMRUNTIME
                                --     -- "${3rd}/luv/library"
                                --     -- "${3rd}/busted/library",
                                -- }
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
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
        local client = vim.lsp.get_client_by_id(args.data.client_id)

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

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup(
                "FormatModificationsOnSave",
                { clear = false }
            ),
            buffer = buffer,
            callback = function()
                local result = require("lsp-format-modifications")
                    .format_modifications(client, buffer)
                -- this will fall back to format the entire buffer
                -- if not successful, e.g. if the file is not in vc.
                if not result.success then
                    vim.lsp.buf.format {
                        id = client.id,
                        bufnr = buffer,
                    }
                end
            end,
        })
    end,
})

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
        config = true,
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
}
