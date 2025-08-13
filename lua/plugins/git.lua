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
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git: Open panel" },
      { "<leader>hd", "<cmd>DiffviewOpen<cr>", desc = "Git: Open 3 way conflict resolution" },
    },
    config = function()
      require("neogit").setup({
        disable_commit_confirmation = true,
        disable_insert_on_commit = true,
        remember_settings = true,
        integrations = {
          diffview = true,
          telescope = true,
        },
        builders = {
          NeogitCommitPopup = function(popup)
            local override = require("scripts.override-neogit-flag")
            override.enableAndPersist(popup, { "no-verify" })
          end,
          NeogitPushPopup = function(popup)
            local override = require("scripts.override-neogit-flag")
            override.enableAndPersist(popup, { "force" })
          end,
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
      { "<leader>hb", "<cmd> Gitsigns blame<cr>", desc = "Git: Show file blame" },
    },
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.toggle_current_line_blame(true)
    end,
  },
}
