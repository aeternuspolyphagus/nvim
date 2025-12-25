return {
  "ryutaro-asada/partial-diff.nvim",
  cmd = {
    "PartialDiffA",
    "PartialDiffB",
    "PartialDiffDelete",
  },
  keys = {
    {
      "<leader>bmf",
      ":PartialDiffFrom<CR>",
      mode = "v",
      desc = "Partial Diff: Set region From",
    },
    {
      "<leader>bmt",
      ":PartialDiffTo<CR>",
      mode = "v",
      desc = "Partial Diff: Set region To and show diff",
    },
    {
      "<leader>bmd",
      "<cmd>PartialDiffDelete<CR>",
      mode = "n",
      desc = "Partial Diff: Delete current diff",
    },
  },
}
