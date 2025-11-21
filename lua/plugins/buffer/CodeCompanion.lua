return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "GEMINI_API_KEY",
            },
            schema = {
              model = {
                default = "gemini-2.0-flash-exp",
                choices = {
                  "gemini-2.0-flash-exp",
                  "gemini-1.5-flash-latest",
                  "gemini-1.5-pro-latest",
                },
              },
            },
          })
        end,
      },
      strategies = {
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
        agent = { adapter = "gemini" },
      },
      display = {
        action_palette = {
          provider = "snacks",
        },
        chat = {
          show_settings = true,
          show_token_count = true,
          separator = "─",
        },
      },
    })

    -- Горячие клавиши
    local map = vim.keymap.set
    map("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Chat" })
    map("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "Actions" })
    map({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "Inline Prompt" })
    map("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "Actions (Visual)" })

    -- Закрытие чата по 'q'
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "codecompanion",
      callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
      end,
    })
  end,
}
