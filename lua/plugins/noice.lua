return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {},
  dependencies = {
    -- https://github.com/folke/noice.nvim/issues/1082
    {
      "MunifTanjim/nui.nvim",
      commit = "8d3bce9764e627b62b07424e0df77f680d47ffdb",
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
