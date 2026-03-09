return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "Exafunction/codeium.nvim",
    },
  },
  opts = {
    completion = {
      ghost_text = {
        enabled = true,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "codeium" },
      providers = {
        codeium = { name = "Codeium", module = "codeium.blink", async = true },
      },
    },
  },
}
