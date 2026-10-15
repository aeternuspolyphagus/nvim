return {
  "mason-org/mason.nvim",
  event = "BufReadPre",
  lazy = true,
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "powershell-editor-services",
    },
  },
}
