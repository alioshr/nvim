-- Allow nice navigation between Vim and Tmux panes
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate to left tmux pane" },
    { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate to down tmux pane" },
    { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate to up tmux pane" },
    { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate to right tmux pane" },
    { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate to previous tmux pane" },
  },
}
