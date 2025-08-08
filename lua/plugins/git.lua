return {
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    config = function()
      require("neogit").setup({
        disable_commit_confirmation = true,
        disable_insert_on_commit = true,
        integrations = {
          diffview = true,
          telescope = true,
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    keys = {
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Git: Stage Hunk" },
      { "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Git: Stage Buffer" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Git: Preview Hunk" },
      { "<leader>hi", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Git: Preview Hunk Inline" },
      { "<leader>hv", "<cmd>Gitsigns select_hunk<cr>", desc = "Git: Select Hunk" },
    },
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.toggle_current_line_blame(true)
    end,
  },
}
