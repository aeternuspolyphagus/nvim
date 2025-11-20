-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.wrap = true
-- vim.opt.linebreak = true
-- vim.opt.breakindent = true
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "pwsh.exe"
  vim.opt.shellcmdflag = "-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
-- vim.o.guicursor = "n-v-c-sm:block,n-v-c-sm:hor20,i-ci-ve:ver25,r-cr-o:hor20"
