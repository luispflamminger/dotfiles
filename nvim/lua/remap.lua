vim.g.mapleader = " "

-- open netrw in current folder
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- yank to clipboard
vim.keymap.set("", "<leader>y", "\"+y")
vim.keymap.set("", "<leader>y", "\"+y")
vim.keymap.set("", "<leader>Y", "\"+Y")

-- Paste over selection without replacing register contents
vim.keymap.set("x", "<leader>p", [["_dP]])
