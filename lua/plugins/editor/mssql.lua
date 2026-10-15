return {
  "Kurren123/mssql.nvim",
  event = "BufReadPre",
  lazy = true,
  opts = {
    -- optional
    keymap_prefix = "<leader>m",
  },
  -- optional
  dependencies = { "folke/which-key.nvim" },
}
