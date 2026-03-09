return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    config = function()
      require("codeium").setup({
        enable_cmp_source = false, -- отключаем cmp integration
        enable_chat = false,
        virtual_text = { enabled = true },

        key_bindings = {
          accept = "<Tab>", -- принять текущее предложение
          accept_word = false,
          accept_line = false,
          next = "<A-n>", -- Alt+n = следующий вариант
          prev = "<A-N>", -- Alt+Shift+n = предыдущий вариант
          clear = "<S-c>", -- Shift+c = очистка ghost text
        },
      })
    end,
  },
}
