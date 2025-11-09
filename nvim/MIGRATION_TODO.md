# LazyVim Migration Checklist

## What Was Migrated ✅

- ✅ **Harpoon2** - Added LazyVim extra (`lazyvim.plugins.extras.editor.harpoon2`)
- ✅ **Obsidian.nvim** - Full config with all keybindings (`<leader>oo`, `os`, `ob`, `ot`, `on`, `oe`)
- ✅ **Bamboo colorscheme** - With visible tabs/spaces settings
- ✅ **Markdown preview** - `markdown-preview.nvim` plugin

## Things to Evaluate Yourself

### Essential Settings to Configure

- [x] **Indentation**: LazyVim defaults to 2 spaces. Your old config used 4 spaces.
  - Add to `lua/config/options.lua` if you want 4 spaces back:
    ```lua
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    ```

- [x] **Editor settings**: Your old config had these settings:
  - Add to `lua/config/options.lua` if wanted:
    ```lua
    vim.opt.scrolloff = 8
    vim.opt.colorcolumn = "80"
    vim.opt.wrap = false
    vim.opt.swapfile = false
    ```

- [x] **Harpoon keybindings**: Test LazyVim's default Harpoon bindings
  - Your old bindings: `<leader>h` (add), `<C-h>` (menu), `<C-j/k/l/;>` (select 1-4)
  - Check if LazyVim's defaults work for you or need customization

### File Navigation & UI

- [x] **Neo-tree vs nvim-tree**: LazyVim uses neo-tree instead of nvim-tree
  - Try it: `<leader>e` to toggle
  - Evaluate if you prefer it or want to switch back to nvim-tree

- [x] **Flash.nvim vs leap.nvim**: LazyVim uses flash for enhanced motion
  - Try it: Press `s` in normal mode
  - Your old config used leap.nvim with default mappings

### Git Integration

- [x] **Gitsigns**: Verify inline git blame is working
  - LazyVim includes gitsigns by default
  - Your old config had `current_line_blame = true` with 300ms delay

### Formatting

- [x] **Conform.nvim**: Test format-on-save behavior
  - Toggle format-on-save per buffer: `<leader>uf`
  - Toggle format-on-save globally: `<leader>uF`
  - Manual format: `<leader>cf`
  - Note: This formats the entire buffer, not just modifications like your old setup

### LSP & Language Support (if needed)

- [ ] **Java/JDTLS**: If you do Java development
  - Need to add JDTLS config with Lombok support
  - Your old config had: `-javaagent:/home/luisp/.local/share/java/lombok.jar`
  - Custom workspace dir: `/home/luisp/.cache/jdtls/`
  - Organize imports binding: `<leader>co`

- [ ] **LSP servers**: Verify your language servers work
  - Go (gopls)
  - Python (pylsp)
  - Markdown (marksman)
  - XML (lemminx)
  - TypeScript/JavaScript (ts_ls) with custom 2-space indent
  - Deno (denols) with custom root detection
  - Lua (lua_ls)

- [ ] **nvim-lint**: If you need golangcilint
  - Your old config had automatic linting on BufEnter and BufWritePost

### Nice-to-Have Plugins

- [x] **nvim-spectre**: Project-wide search and replace UI
  - Your old config had this with `<leader>` keybindings (check telescope for alternatives)

- [x] **Custom keybindings**: Your old custom keymaps
  - `<leader>pv` - Open netrw in current folder
  - `<leader>y` - Yank to system clipboard
  - `<leader>p` - Paste over selection without overwriting register
  - Add these to `lua/config/keymaps.lua` if wanted

- [x] **Telescope custom function**: `move_current_file` with `<leader>mf`
  - Interactive file move picker using telescope

### LazyVim Features to Explore

- [x] **Which-key**: Press `<leader>` and wait to see available keybindings
- [x] **Telescope**: `<leader>ff` (find files), `<leader>fg` (live grep), etc.
- [x] **Trouble**: Diagnostics UI (check if it works for you)
- [x] **LazyVim extras**: Browse available extras at `:LazyExtras`

## Notes

- LazyVim provides many features out-of-the-box that you previously configured manually
- Explore LazyVim defaults first before re-adding custom configs
- Check `:LazyExtras` for pre-configured language support and additional features
- Default keybindings: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
