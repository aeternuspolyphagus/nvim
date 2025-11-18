return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  main = "ibl",
  opts = {
    indent = {
      highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      },
      char = "│", -- тонкая линия (можно │ или ┊)
    },
    whitespace = {
      highlight = {
        "IblWhitespace",
      }, -- теперь пробелы тоже радужные
      remove_blankline_trail = false, -- оставляем trailing пробелы видимыми
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      char = "│",
      highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      },
    },
    exclude = {
      buftypes = { "terminal", "nofile" },
      filetypes = { "help", "dashboard", "alpha", "lazy" },
    },
  },
  config = function(_, opts)
    local hooks = require("ibl.hooks")
    -- Определяем цвета один раз и автоматически при смене colorscheme
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" }) -- красный
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" }) -- жёлтый
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" }) -- синий
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" }) -- оранжевый
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" }) -- зелёный
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" }) -- фиолетовый
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" }) -- циан
    end)
    vim.api.nvim_set_hl(0, "IblWhitespace", { bg = "#3B4261" })
    -- Поддержка rainbow-delimiters.nvim для scope-подсветки
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

    require("ibl").setup(opts)
  end,
}
