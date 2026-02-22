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

-- Remove empty command-line row (Noice handles cmdline via popups)
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.laststatus = 3

-- theme
vim.o.background = "light"

-- Global fold UX defaults (works with treesitter foldexpr and others)
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 3
vim.opt.foldminlines = 6
vim.opt.fillchars:append({
  foldopen = "-",
  foldclose = "+",
  foldsep = " ",
  fold = " ",
})

local function set_pmenu_highlights()
  vim.api.nvim_set_hl(0, "Pmenu", { link = "NormalFloat" })
  vim.api.nvim_set_hl(0, "PmenuSel", { link = "Visual" })
  vim.api.nvim_set_hl(0, "PmenuKind", { link = "Pmenu" })
  vim.api.nvim_set_hl(0, "PmenuExtra", { link = "Pmenu" })
end

set_pmenu_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("PmenuHighlights", { clear = true }),
  callback = set_pmenu_highlights,
})
