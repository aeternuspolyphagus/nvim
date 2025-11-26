return {
  "ryutaro-asada/partial-diff.nvim",
  cmd = {
    "PartialDiffA",
    "PartialDiffB",
    "PartialDiffDelete",
  },
  keys = {
    {
      "<leader>bdf",
      ":PartialDiffFrom<CR>",
      mode = "v",
      desc = "Partial Diff: Set region From",
    },
    {
      "<leader>bdt",
      ":PartialDiffTo<CR>",
      mode = "v",
      desc = "Partial Diff: Set region To and show diff",
    },
    {
      "<leader>bdd",
      "<cmd>PartialDiffDelete<CR>",
      mode = "n",
      desc = "Partial Diff: Delete current diff",
    },
  },
}
