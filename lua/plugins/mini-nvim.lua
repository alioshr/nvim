return {
  "echasnovski/mini.nvim",
  lazy = false,
  version = "*",
  config = function()
    require("mini.ai").setup({
      mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        goto_left = "g[",
        goto_right = "g]",
      },
    })
    require("mini.surround").setup({
      -- Using '?' - interactive. Prompts user to enter left and right parts.
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    })
    -- Here we are just using mini.diff for inline hunk visualization and jumping between hunks.
    -- The rest of this functionality is managed by GitSigns
    require("mini.diff").setup({
      view = {
        style = "sign",
        -- Here we force no signs to show, as we prefer Gitsigns signs
        signs = { add = "", change = "", delete = "" },
      },
    })
    require("mini.operators").setup()
    require("mini.pairs").setup()
    require("mini.bracketed").setup()
    require("mini.splitjoin").setup()
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
    require("mini.jump2d").setup()
  end,
  -- Here we are just using mini.diff for inline hunk visualization and jumping between hunks.
  -- The rest of this functionality is managed by GitSigns
  keys = {
    {
      "<leader>gv",
      function()
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "MiniDiff: Toggle Git Diff Overlay",
    },
    {
      "<leader>]+",
      function()
        require("mini.diff").goto_hunk("next")
      end,
      desc = "MiniDiff: Go to Next Git Diff Hunk",
    },
    {
      "<leader>[è",
      function()
        require("mini.diff").goto_hunk("prev")
      end,
      desc = "MiniDiff: Go to Previous Git Diff Hunk",
    },
  },
}
