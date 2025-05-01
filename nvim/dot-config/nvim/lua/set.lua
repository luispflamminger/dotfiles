-- line numbers
vim.wo.relativenumber = true
vim.wo.number = true

-- indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- editor
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"

-- netrw
vim.g.netrw_banner = 0    -- disable banner
vim.g.netrw_altv = 1      -- open splits to the right
-- vim.g.netrw_liststyle = 3 -- tree view

-- required for deno docs
vim.g.markdown_fenced_languages = {
    "ts=typescript"
}

-- no swap files
vim.opt.swapfile = false
