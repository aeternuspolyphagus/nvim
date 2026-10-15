return {
  "mason-org/mason.nvim",
  event = "BufReadPre",
  lazy = false,
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "powershell-editor-services",
    },
  },
}
