return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = true,
        },
      },

      keymap = {
        ["<Tab>"] = {
          "accept",
          "fallback",
        },

        ["<S-Tab>"] = {
          "select_prev",
          "fallback",
        },
      },
    },
  },
}
