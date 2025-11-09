return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "mdx" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
