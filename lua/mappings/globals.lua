-- Global key mappings for Neovim

-- Navigate to the previous buffer
vim.keymap.set("n", "-", vim.cmd.Ex, { desc = "Open file explorer" })

-- Escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape insert mode with jj" })
vim.keymap.set("i", "dd", "<Esc>", { desc = "Escape insert mode with dd" })

-- Clear search highlight
vim.keymap.set("n", "<leader>us", ":noh<CR>", { desc = "Clear search highlight" })

-- Copy the path of the current buffer
vim.keymap.set("n", "<leader>cp", ":let @+=expand('%:p')<CR>", { desc = "Copy the path of the current buffer" })

-- Copy the project root path
vim.keymap.set("n", "<leader>cr", ":let @+=getcwd()<CR>", { desc = "Copy the project root path" })

-- Close a buffer
vim.keymap.set("n", "<leader>c", ":bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>C", ":bd!<CR>", { desc = "Force close current buffer" })

-- Close neovim
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all buffers" })

--Source
vim.keymap.set("n", "<leader>so", ":so %<CR>", { desc = "Source current file" })
