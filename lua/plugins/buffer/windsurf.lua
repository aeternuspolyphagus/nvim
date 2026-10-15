return {
  {
    "Exafunction/windsurf.nvim",
    event = "InsertEnter",
    lazy = true,
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        enable_chat = false,
        virtual_text = {
          enabled = false,
        },
      })
    end,
  },
}
