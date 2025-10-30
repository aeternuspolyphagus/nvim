return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = { "copilot", "powershell_es" },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
