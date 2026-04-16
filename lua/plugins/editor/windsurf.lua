return {
  {
    "Exafunction/codeium.nvim",
    event = "BufEnter",
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        enable_chat = false,
        virtual_text = {
          enabled = true,
          show = false,
          manual = false,
          idle_delay = 75,
          map_keys = false,
        },
      })
    end,
  },
}
