-- lazy.nvim:
return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    vim.g.VM_default_mappings = false
    vim.g.VM_maps = {
      ["Find Under"] = "<C-z>", -- Ctrl+d для выделения слова
      ["Find Subword Under"] = "<C-z>",
      ["Add Cursor Down"] = "<C-j>", -- или <C-j>
      ["Add Cursor Up"] = "<C-k>", -- или <C-k>
      ["Goto Next"] = "<C-n>",
      ["Goto Prev"] = "<C-p>",
    }
  end,
}
