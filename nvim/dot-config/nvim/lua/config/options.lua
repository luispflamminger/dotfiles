-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Keep system clipboard separate from vim registers
-- Use <leader>y to explicitly yank to system clipboard (see keymaps.lua)
vim.opt.clipboard = ""

-- Increase timeout to give enough time to complete multi-key sequences like
-- <leader><tab>[ after the which-key popup appears (LazyVim default: 300ms)
vim.opt.timeoutlen = 500

-- Swap files cause E325 interruptions when opening files; recovery is rarely
-- needed given git covers most unsaved-work scenarios
vim.opt.swapfile = false
