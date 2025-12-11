return {
  {
    "nvim-mini/mini.hipatterns",
    version = false, -- Используйте последнюю версию
    lazy = false, -- Загружайте сразу для ранней инициализации
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          critical = {
            pattern = { "#FIXME", "#BUG", "#ERROR", "#FAIL" },
            group = "MiniHipatternsCritical",
            extmark_opts = { priority = 200 },
          },
          warning = {
            pattern = { "#HACK", "#WARNING", "#PERF", "#OPTIMIZE" },
            group = "MiniHipatternsWarning",
            extmark_opts = { priority = 200 },
          },
          note = {
            pattern = { "#NOTE", "#HINT", "#IDEA", "#TODO" },
            group = "MiniHipatternsNote",
            extmark_opts = { priority = 200 },
          },
          important = {
            pattern = { "#CRITICAL", "#URGENT", "#DEADLINE", "#REVIEW", "#INFO reworked" },
            group = "MiniHipatternsImportant",
            extmark_opts = { priority = 200 },
          },
          hex_color = hipatterns.gen_highlighter.hex_color({ priority = 200 }),
        },
      })
      local hi = vim.api.nvim_set_hl
      hi(0, "MiniHipatternsCritical", { fg = "#f4a261", bg = "#9a3412", bold = true })
      hi(0, "MiniHipatternsWarning", { fg = "#000000", bg = "#fbbf24", bold = true }) -- Тёмный текст на жёлтом
      hi(0, "MiniHipatternsNote", { fg = "#ffffff", bg = "#34d399", bold = true }) -- Белый текст на зелёном
      hi(0, "MiniHipatternsImportant", { fg = "#000000", bg = "#a78bfa", bold = true, underline = true }) -- Тёмный текст на фиолетовом
    end,
  },
}
