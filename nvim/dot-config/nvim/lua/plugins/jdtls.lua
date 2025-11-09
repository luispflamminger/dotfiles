-- Java/JDTLS configuration migrated from old config
return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "java", "kt", "kts" },
    config = function()
      local jdtls_mason_path = "/home/luisp/.local/share/nvim/mason/bin/jdtls"
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local jdtls_cache_dir = "/home/luisp/.cache/jdtls/"
      local workspace_dir = jdtls_cache_dir .. "workspace/" .. project_name
      local config_dir = jdtls_cache_dir .. "config/"

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        group = vim.api.nvim_create_augroup("JdtlsAttach", {}),
        callback = function(_)
          require("jdtls").start_or_attach({
            cmd = {
              jdtls_mason_path,
              "-configuration",
              config_dir,
              "-data",
              workspace_dir,
              "--jvm-arg=-javaagent:/home/luisp/.local/share/java/lombok.jar",
            },
            settings = {
              java = {
                saveActions = { organizeImports = true },
                import = { exclusions = "target/*" },
                sources = { organizeImports = { starThreshold = 5, staticStarThreshold = 3 } },
              },
            },
            root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
          })

          -- Organize imports keybinding
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" } },
              apply = true,
            })
          end, { desc = "Organize imports", buffer = true })
        end,
      })
    end,
  },
}