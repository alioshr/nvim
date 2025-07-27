return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    require("mini.ai").setup()
    require("mini.surround").setup()
    require("mini.operators").setup()
    require("mini.pairs").setup()
    require("mini.bracketed").setup()
    require("mini.indentscope").setup()
    require("mini.diff").setup({
      view = {
        style = "sign",
      },
    })
  end,
  keys = {
    {
      "<leader>gv",
      function()
        require("mini.diff").toggle_overlay()
      end,
      desc = "Toggle Comment",
    },
  },
}
