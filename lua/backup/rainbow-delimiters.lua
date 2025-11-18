return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "BufReadPre",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")

    -- Настройка highlight групп с теми же цветами, что и в indent-blankline
    vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
        powershell = rainbow_delimiters.strategy["global"], -- Добавить
        ps1 = rainbow_delimiters.strategy["global"], -- Добавить (альтернативное имя)
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        powershell = "rainbow-delimiters", -- Добавить
        ps1 = "rainbow-delimiters", -- Добавить
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
}
