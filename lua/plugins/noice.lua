return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
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
