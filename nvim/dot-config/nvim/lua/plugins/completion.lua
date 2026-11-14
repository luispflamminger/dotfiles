-- Completion keybindings:
--   <Tab>   → accept selected completion item
--   <S-Tab> → navigate to previous item
--   <CR>    → always plain newline, never accepts completion
return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        -- Tab accepts the selected completion item
        ["<Tab>"] = { "select_and_accept", "fallback" },
        -- S-Tab navigates to previous item
        ["<S-Tab>"] = { "select_prev", "fallback" },
        -- Enter is always a plain newline
        ["<CR>"] = { "fallback" },
      },
    },
  },
}
