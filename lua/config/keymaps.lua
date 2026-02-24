-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>bsp", function()
  vim.cmd([[
    %s/\v([(\[{])\zs\S/ \0/gc
    %s/\v\S\ze[)\]}]/\0 /gc
  ]])
end, { desc = "Add spaces inside brackets" })

vim.keymap.set("v", "<leader>sp", function()
  vim.cmd([[
    '<,'>s/\v([(\[{])\zs\S/ \0/gc
    '<,'>s/\v\S\ze[)\]}]/\0 /gc
  ]])
end, { desc = "Add spaces inside brackets (selection)" })
