return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "OXY2DEV/markview.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      -- Keymaps are now set in config to ensure plugin is loaded
    },
    config = function()
      require("codecompanion").setup({
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
        },
        strategies = {},
      })

      -- Keymaps defined here to ensure plugin is loaded
      local cc = require("codecompanion")
      vim.keymap.set("n", "<leader>cC", cc.chat, { desc = "Code Companion Chat" })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    opts = {
      extensions = { "codecompanion" },
      strategies = { "chat" },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
