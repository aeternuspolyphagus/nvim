return {
  "nvim-mini/mini.map",
  version = false, -- Используйте последнюю версию
  config = function()
    local MiniMap = require("mini.map")
    MiniMap.setup({
      -- Основные настройки (по умолчанию; кастомизируйте при необходимости)
      integrations = {
        MiniMap.gen_integration.builtin_search(),
        MiniMap.gen_integration.gitsigns(),
        MiniMap.gen_integration.diagnostic(),
      },
      mappings = {
        toggle = "<leader>umm", -- Переключить карту (toggle)
        focus = "<leader>umf", -- Фокусировать карту (toggle focus)
      },
      window = {
        side = "right", -- Сторона окна (left/right)
        width = 10, -- Ширина
      },
    })
    local map = vim.keymap.set
    map("n", "<Leader>umc", MiniMap.close, { desc = "Close MiniMap" })
    map("n", "<Leader>umf", MiniMap.toggle_focus, { desc = "Toggle MiniMap focus" })
    map("n", "<Leader>umo", MiniMap.open, { desc = "Open MiniMap" })
    map("n", "<Leader>umr", MiniMap.refresh, { desc = "Refresh MiniMap" })
    map("n", "<Leader>ums", MiniMap.toggle_side, { desc = "Toggle MiniMap side" })
    map("n", "<Leader>umt", MiniMap.toggle, { desc = "Toggle MiniMap" })
  end,
}
