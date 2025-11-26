return {
  "ryutaro-asada/partial-diff.nvim",
  cmd = {
    "PartialDiffA",
    "PartialDiffB",
    "PartialDiffDelete",
  },
  keys = {
    {
      "<leader>bcf",
      ":PartialDiffFrom<CR>",
      mode = "v",
      desc = "Partial Diff: Set region From",
    },
    {
      "<leader>bct",
      ":PartialDiffTo<CR>",
      mode = "v",
      desc = "Partial Diff: Set region To and show diff",
    },
    {
      "<leader>bcd",
      "<cmd>PartialDiffDelete<CR>",
      mode = "n",
      desc = "Partial Diff: Delete current diff",
    },
  },
}
