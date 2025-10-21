return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {},
  dependencies = {
    {
      "MunifTanjim/nui.nvim",
    },
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 0,
        stages = "fade",
        render = "minimal",
      },
    },
    lsp = {},
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  },
}
