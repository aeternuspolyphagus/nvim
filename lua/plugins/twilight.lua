return {
  "folke/twilight.nvim",
  opts = {
    -- Базовые настройки (по умолчанию; кастомизируйте при необходимости)
    dimming = {
      alpha = 0.25, -- Уровень затемнения
      color = { "Normal", "#ffffff" }, -- Цвет затемнения
      term_bg = "#000000", -- Фон терминала
      inactive = false, -- Затемнять неактивные окна (если не тот же буфер)
    },
    context = 10, -- Количество строк контекста вокруг текущей
    treesitter = true, -- Использовать Tree-sitter
    expand = {
      "function", -- Типы узлов для расширения
      "method",
      "table",
      "if_statement",
    },
    exclude = {}, -- Исключаемые типы файлов
  },
  config = function(_, opts)
    require("twilight").setup(opts)
    local map = vim.keymap.set
    map("n", "<leader>ctt", "<cmd>Twilight<cr>", { desc = "Toggle Twilight" })
    map("n", "<leader>cte", "<cmd>TwilightEnable<cr>", { desc = "Enable Twilight" })
    map("n", "<leader>ctd", "<cmd>TwilightDisable<cr>", { desc = "Disable Twilight" })
  end,
}
