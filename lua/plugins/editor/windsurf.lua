return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        enable_chat = false,
        virtual_text = {
          enabled = true,
        },
      })
    end,
  },
}
