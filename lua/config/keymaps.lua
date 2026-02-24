-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>bsb", function()
  vim.cmd([[
    %s/\v([(\[{])\zs\S/ \0/gc
    %s/\v\S\ze[)\]}]/\0 /gc
  ]])
end, { desc = "Add spaces inside brackets" })

vim.keymap.set("v", "<leader>bsb", function()
  vim.cmd([[
    '<,'>s/\v([(\[{])\zs\S/ \0/gc
    '<,'>s/\v\S\ze[)\]}]/\0 /gc
  ]])
end, { desc = "Add spaces inside brackets (selection)" })

vim.keymap.set("n", "<leader>bsq", function()
  vim.cmd([[
    %s/'/"/gc
  ]])
end, { desc = "Change quotation marks" })

vim.keymap.set("v", "<leader>bsq", function()
  vim.cmd([[
    '<,'>s/'/"/gc
  ]])
end, { desc = "Change quotation (selection)" })

vim.keymap.set("n", "<leader>bst", function()
  vim.cmd([[
    %s/\s\+$//
  ]])
end, { desc = "Delete tailing spaces" })

vim.keymap.set("v", "<leader>bst", function()
  vim.cmd([[
    '<,'>s/\s\+$//
  ]])
end, { desc = "Delete tailing spaces (selection)" })
