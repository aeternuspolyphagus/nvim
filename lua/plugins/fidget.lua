return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    progress = {
      display = {
        render_limit = 3, -- сколько одновременно отображать
        progress_icon = { pattern = "dots", period = 1 },
      },
    },
    notification = {
      window = {
        relative = "editor",
        blend = 0, -- без прозрачности
      },
    },
  },
}
