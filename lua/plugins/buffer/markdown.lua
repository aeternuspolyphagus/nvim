return {
  {
    "delphinus/md-render.nvim",
    version = "*",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", version = "*" }, -- optional: file type icons in code blocks
      { "delphinus/budoux.lua", version = "*" }, -- optional: CJK phrase-level line breaking
    },
    keys = {
      { "<leader>cmp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
      { "<leader>cmt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
      { "<leader>cmd", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
    },
  },
  {
    "phrmendes/todotxt.nvim",
    ft = { "todotxt" },
    config = function()
      vim.filetype.add({
        filename = {
          ["todo.txt"] = "todotxt",
          ["done.txt"] = "todotxt",
        },
      })

      require("todotxt").setup({})
    end,
  },
}
