return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 49, -- Load BEFORE treesitter
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
}