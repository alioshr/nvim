return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim", -- Optional: For WtfGrepHistory
  },
  opts = {
    provider = "copilot",
    popup_type = "popup",
    providers = {
      copilot = {
        model_id = "claude-sonnet-4",
      },
    },
  },
  keys = {
    {
      "<leader>wd",
      mode = { "n", "x" },
      function()
        require("wtf").diagnose()
      end,
      desc = "Wtf Diagnostics: Debug diagnostic with AI",
    },
    {
      "<leader>wf",
      mode = { "n", "x" },
      function()
        require("wtf").fix()
      end,
      desc = "Wtf Diagnostics: Fix diagnostic with AI",
    },
    {
      mode = { "n" },
      "<leader>ws",
      function()
        require("wtf").search()
      end,
      desc = "Wtf Diagnostics: Search diagnostic with Google",
    },
    {
      mode = { "n" },
      "<leader>wp",
      function()
        require("wtf").pick_provider()
      end,
      desc = "Wtf Diagnostics: Pick provider",
    },
    {
      mode = { "n" },
      "<leader>wh",
      function()
        require("wtf").history()
      end,
      desc = "Wtf Diagnostics: Populate the quickfix list with previous chat history",
    },
    {
      mode = { "n" },
      "<leader>wg",
      function()
        require("wtf").grep_history()
      end,
      desc = "Wtf Diagnostics: Grep previous chat history with Telescope",
    },
  },
}
