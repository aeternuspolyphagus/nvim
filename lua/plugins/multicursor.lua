-- lazy.nvim:
return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    vim.g.VM_default_mappings = false
    vim.g.VM_maps = {
      ["Find Under"] = "<C-d>", -- Ctrl+d для выделения слова
      ["Find Subword Under"] = "<C-d>",
      ["Add Cursor Down"] = "<C-Down>", -- или <C-j>
      ["Add Cursor Up"] = "<C-Up>", -- или <C-k>
      ["Goto Next"] = "<C-n>",
      ["Goto Prev"] = "<C-p>",
    }
  end,
}
