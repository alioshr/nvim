-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.mapleader = " " -- easy to reach leader key

-- Show numbers on the lines
vim.opt.number = true
vim.api.nvim_create_autocmd("InsertEnter", { command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { command = [[set relativenumber]] })
vim.opt.clipboard = "unnamedplus"
