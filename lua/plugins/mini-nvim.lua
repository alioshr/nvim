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
    require("mini.jump").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = ";",
      },

      -- Delay values (in ms) for different functionalities. Set any of them to
      -- a very big number (like 10^7) to virtually disable.
      delay = {
        -- Delay between jump and highlighting all possible jumps
        highlight = 250,

        -- Delay between jump and automatic stop if idle (no jump is done)
        idle_stop = 10000000,
      },

      -- Whether to disable showing non-error feedback
      -- This also affects (purely informational) helper messages shown after
      -- idle time if user input is required.
      silent = false,
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
