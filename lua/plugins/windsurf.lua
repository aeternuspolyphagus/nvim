return {
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp", -- Required for completion integration; ensure nvim-cmp is configured prior.
    },
    event = "InsertEnter", -- Enables lazy loading: plugin loads only when entering insert mode.
    config = function()
      require("codeium").setup({
        -- Default setup with no custom options; adjust as needed (e.g., for API keys or virtual text).
        -- Example optional settings:
        -- enable_cmp_source = true,  -- Registers as a cmp source (default: true).
        -- enable_chat = true,       -- Enables chat functionality if desired.
        -- virtual_text = { enabled = false },  -- Disables virtual text completions by default.
      })
    end,
  },
}
