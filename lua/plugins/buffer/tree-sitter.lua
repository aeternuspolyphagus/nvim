return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPre",
  lazy = false,
  opts = {
    ensure_installed = {
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "regex",
      "yaml",
      "toml",
      "powershell",
    },
  },
}
