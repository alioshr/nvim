-- Global key mappings for Neovim

-- Navigate to the previous buffer
vim.keymap.set("n", "-", vim.cmd.Ex, { desc = "Open file explorer" })

-- Save the current buffer and format
local fixAndFormat = require("scripts.fixAndFormat").fixAndFormat

vim.keymap.set("n", "<leader>w", function()
  fixAndFormat(function()
    vim.cmd("w")
  end)
end, { desc = "Save current buffer" })

-- Escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape insert mode with jj" })

-- Clear search highlight
vim.keymap.set("n", "<leader>us", ":noh<CR>", { desc = "Clear search highlight" })

-- Copy the path of the current buffer
local utils = require("scripts.utils")
vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", utils.get_current_file_abs_path())
end, { desc = "Copy the path of the current buffer" })

-- Copy the project root path
vim.keymap.set("n", "<leader>cr", function()
  vim.fn.setreg("+", utils.get_cwd_path())
end, { desc = "Copy the project root path" })

-- Close a buffer
vim.keymap.set("n", "<leader>c", ":bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>C", ":bd!<CR>", { desc = "Force close current buffer" })

-- Close neovim
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Quit Neovim" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all buffers" })

--Source
vim.keymap.set("n", "<leader>so", ":so %<CR>", { desc = "Source current file" })

-- Split creation
vim.keymap.set("n", "SH", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "SV", ":vsplit<CR>", { desc = "Vertical split" })

-- Split navigation
vim.keymap.set("n", "<localleader>h", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<localleader>j", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<localleader>k", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<localleader>l", "<C-w>l", { desc = "Move to right split" })

-- Split resize
vim.keymap.set("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Decrease split width" })
vim.keymap.set("n", "<A-Down>", ":resize +2<CR>", { desc = "Increase split height" })
vim.keymap.set("n", "<A-Up>", ":resize -2<CR>", { desc = "Decrease split height" })
vim.keymap.set("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Increase split width" })

-- Acess registers
vim.keymap.set("n", "<localleader>r", ":registers<CR>", { desc = "Show registers" })

-- Quickfix list operations
local quickFixList = require("scripts.quick-fix-list")
vim.keymap.set("n", "<leader>rq", quickFixList.replaceInQuickFixList, { desc = "Replace in quickfix list" })

-- Tmux floating terminal (default session)
local tmux = require("scripts.tmux")
vim.keymap.set("n", "U", tmux.createFloatingTerminal, { desc = "Trigger tmux floating terminal (default session)" })

-- Surround stuff easily
vim.keymap.set("v", "qq", 'c""<esc>P')
vim.keymap.set("v", "sq", "c''<esc>P")
vim.keymap.set("v", "qw", "c``<esc>P")
vim.keymap.set("v", "[[", "c[]<esc>P")
vim.keymap.set("v", "(", "c()<esc>P")
vim.keymap.set("v", "{", "c{}<esc>P")

-- Jump 5 lines up and down
vim.keymap.set({ "n", "v" }, "J", "5j", { desc = "Jump 5 lines down" })
vim.keymap.set({ "n", "v" }, "K", "5k", { desc = "Jump 5 lines up" })

-- Fold mappings (custom shortcuts + explicit defaults so they are discoverable in Telescope)
vim.keymap.set("n", "<leader>zt", "<Cmd>normal! za<CR>", { desc = "Folds: Toggle fold under cursor" })
vim.keymap.set("n", "<leader>zc", "<Cmd>normal! zc<CR>", { desc = "Folds: Close fold under cursor" })
vim.keymap.set("n", "<leader>zo", "<Cmd>normal! zo<CR>", { desc = "Folds: Open fold under cursor" })
vim.keymap.set("n", "<leader>zC", "<Cmd>normal! zM<CR>", { desc = "Folds: Close all folds in buffer" })
vim.keymap.set("n", "<leader>zO", "<Cmd>normal! zR<CR>", { desc = "Folds: Open all folds in buffer" })

vim.keymap.set("n", "za", "<Cmd>normal! za<CR>", { desc = "Folds: Toggle fold under cursor (default)" })
vim.keymap.set("n", "zc", "<Cmd>normal! zc<CR>", { desc = "Folds: Close fold under cursor (default)" })
vim.keymap.set("n", "zo", "<Cmd>normal! zo<CR>", { desc = "Folds: Open fold under cursor (default)" })
vim.keymap.set("n", "zC", "<Cmd>normal! zC<CR>", { desc = "Folds: Close fold recursively (default)" })
vim.keymap.set("n", "zO", "<Cmd>normal! zO<CR>", { desc = "Folds: Open fold recursively (default)" })
vim.keymap.set("n", "zM", "<Cmd>normal! zM<CR>", { desc = "Folds: Close all folds in buffer (default)" })
vim.keymap.set("n", "zR", "<Cmd>normal! zR<CR>", { desc = "Folds: Open all folds in buffer (default)" })
vim.keymap.set("n", "zr", "<Cmd>normal! zr<CR>", { desc = "Folds: Reduce folding level (default)" })
vim.keymap.set("n", "zm", "<Cmd>normal! zm<CR>", { desc = "Folds: Increase folding level (default)" })

-- Black hole delete mappings
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole register" })
vim.keymap.set({ "n", "v" }, "D", "d", { desc = "Delete to register (capital D)" })
vim.keymap.set("n", "dd", '"_dd', { desc = "Delete line to black hole register" })
vim.keymap.set("n", "DD", "dd", { desc = "Delete line to register (capital DD)" })

-- Black hole character delete mappings
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete character to black hole register" })
vim.keymap.set("n", "X", "x", { desc = "Delete character to register (capital X)" })

-- Black hole substitute mappings
vim.keymap.set({ "n", "v" }, "s", '"_s', { desc = "Substitute to black hole register" })
vim.keymap.set("n", "S", "s", { desc = "Substitute character to register (capital S)" })

-- Black hole change mappings
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change to black hole register" })
vim.keymap.set("n", "C", "c", { desc = "Change to register (capital C)" })
