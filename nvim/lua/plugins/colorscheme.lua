-- make spaces and tabs visible
vim.opt.list = true
vim.opt.listchars = "tab:→\\x20,space:·"

return {
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({
        transparent = false,
      })
      require("bamboo").load()
    end,
  },
  -- Configure LazyVim to use bamboo
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "bamboo",
    },
  },
}
