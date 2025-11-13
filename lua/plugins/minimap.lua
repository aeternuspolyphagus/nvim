return {
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    opts = {
      current_only = false,
      winblend = 0,
      zindex = 40,
      excluded_filetypes = { "help", "TelescopePrompt", "lsp-installer" },
      width = 2,
      handlers = {
        cursor = { enable = true, symbols = { "⎺", "⎻", "⎼", "⎽" } },
        diagnostic = { enable = true },
        gitsigns = { enable = true },
        marks = { enable = true },
        search = { enable = true },
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim", -- Добавлена зависимость для интеграции с Snacks
    },
    keys = {
      { "<leader>umo", "<cmd>AerialOpen<CR>", desc = "Open Code Outline" },
      { "<leader>umc", "<cmd>AerialClose<CR>", desc = "Close Code Outline" },
      { "<leader>umt", "<cmd>AerialToggle<CR>", desc = "Toggle Code Outline" },
      {
        "<leader>ump",
        function()
          require("aerial").snacks_picker({ layout = { preset = "dropdown", preview = true } })
        end,
        desc = "Aerial Snacks Picker",
      }, -- Новая привязка для Snacks-picker
    },
    opts = {
      backends = { "treesitter", "lsp" },
      layout = {
        max_width = { 40, 0.2 },
        width = 20,
        min_width = 20,
        default_direction = "right",
      },
      attach_mode = "global",
      close_automatic_events = {},
      update_events = { "TextChanged", "InsertLeave" }, -- Новое: события обновления
      lsp = {
        update_delay = 300,
        update_when_errors = true,
      },
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
      },
      show_guides = true,
      filter_kind = false,
    },
  },
}
