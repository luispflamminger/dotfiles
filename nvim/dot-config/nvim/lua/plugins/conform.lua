return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
    },
    formatters = {
      ["google-java-format"] = {
        prepend_args = { "--aosp" },
      },
    },
  },
}
