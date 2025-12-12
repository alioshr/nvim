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
  },
}
