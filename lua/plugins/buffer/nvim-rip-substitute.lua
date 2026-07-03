return {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  event = "BufReadPre",
  opts = {},
  keys = {
    {
      "<leader>rs",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = " rip substitute",
    },
  },
}
