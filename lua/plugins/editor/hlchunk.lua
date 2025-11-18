return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        priority = 5,
        style = {
          { fg = "#d89d7c" },
          { fg = "#c21f30" },
        },
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
        duration = 200,
        delay = 300,
      },
      line_num = {
        enable = true,
        style = "#bdc641",
        priority = 3,
        use_treesitter = true,
      },
      indent = {
        enable = true,
        priority = 2,
        -- style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
        use_treesitter = true,
        chars = {
          "│",
          "¦",
          "┆",
          "┊",
        },
        style = {
          "#FF0000",
          "#FF7F00",
          "#FFFF00",
          "#00FF00",
          "#00FFFF",
          "#0000FF",
          "#8B00FF",
        },
      },
      blank = {
        enable = true,
        priority = 1,
        chars = {
          " ",
        },
        style = {
          { bg = "#434437" },
          { bg = "#2f4440" },
          { bg = "#433054" },
          { bg = "#284251" },
        },
      },
    })
  end,
}
