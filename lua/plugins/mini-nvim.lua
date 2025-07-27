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
    require("mini.move").setup({
      mappings = {
        left = "∆", -- alt + h
        right = "¬", -- alt + l
        down = "ª", -- alt + j
        up = "º", -- alt + k

        line_left = "<leader>∆", -- alt + h
        line_right = "¬", -- alt + l
        line_down = "ª", -- alt + j
        line_up = "º", -- alt + k
      },
    })
  end,
  keys = {
    {
      "<leader>gv",
      function()
        require("mini.diff").toggle_overlay()
      end,
      desc = "Toggle Git Diff Overlay",
    },
  },
}
