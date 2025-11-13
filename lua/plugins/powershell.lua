return {
  "TheLeoP/powershell.nvim",
  dependencies = { "mason-org/mason.nvim" },
  ---@type powershell.user_config
  opts = {
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
  },
}
