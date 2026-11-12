return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPre",
  lazy = true,
  opts = {
    ensure_installed = {
      "json",
      "lua",
      "powershell",
    },
  },
}
