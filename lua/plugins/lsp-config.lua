return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = { "powershell_es" },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
