return {
  "mason-org/mason.nvim",
  event = "BufReadPre",
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "powershell-editor-services",
    },
  },
