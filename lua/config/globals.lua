-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.mapleader = " "

-- Show numbers on the lines
vim.opt.number = true

-- Show relative numbers
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Enable mouse support
vim.opt.mouse = "a"

-- local leader
vim.g.maplocalleader = "z"

-- Add rounded borders to windows
vim.o.winborder = "rounded"

-- Tab settings
vim.opt.tabstop = 2 -- Visual width of tab character
vim.opt.shiftwidth = 2 -- Indent size for << >> commands
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.softtabstop = 2 -- Tab key inserts this many spaces

vim.o.termguicolors = true
