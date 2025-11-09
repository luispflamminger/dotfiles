-- LSP configuration migrated from old config
return {
  -- Mason for managing LSP servers
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "marksman",
        "lemminx",
        "lua-language-server",
        "python-lsp-server",
        "typescript-language-server",
        "deno",
      },
    },
  },

  -- LSP server configurations
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Lua LSP with Neovim configuration
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          },
        },

        -- Go LSP
        gopls = {},

        -- Python LSP
        pylsp = {},

        -- Markdown LSP
        marksman = {},

        -- XML LSP
        lemminx = {},

        -- TypeScript/JavaScript LSP with custom settings
        ts_ls = {
          filetypes = {
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "javascript",
            "javascriptreact",
            "javascript.tsx",
          },
          root_dir = require("lspconfig").util.root_pattern("package.json"),
          single_file_support = false,
          settings = {
            typescript = {
              format = {
                tabSize = 2,
                indentSize = 2,
              },
            },
            javascript = {
              format = {
                tabSize = 2,
                indentSize = 2,
              },
            },
          },
        },

        -- Deno LSP with custom root detection
        denols = {
          root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
        },
      },
    },
  },

  -- Linting configuration
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },
}