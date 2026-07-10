-- Java/JDTLS — delegate to LazyVim's built-in lang/java extra.
-- The extra handles: lombok javaagent, config/workspace dirs, DAP, keymaps.
-- Override opts here if you need project-specific tweaks.
return {
  { import = "lazyvim.plugins.extras.lang.java" },

  -- Optional: override jdtls opts (e.g. custom settings)
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          sources = {
            organizeImports = { starThreshold = 5, staticStarThreshold = 3 },
          },
        },
      },
    },
  },
}
