return {
  "folke/twilight.nvim",
  opts = {},
  config = function(_, opts)
    require("twilight").setup(opts)
    local map = vim.keymap.set
    map("n", "<leader>ctt", "<cmd>Twilight<cr>", { desc = "Toggle Twilight" })
    map("n", "<leader>cte", "<cmd>TwilightEnable<cr>", { desc = "Enable Twilight" })
    map("n", "<leader>ctd", "<cmd>TwilightDisable<cr>", { desc = "Disable Twilight" })
  end,
}
