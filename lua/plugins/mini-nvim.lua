return {
  "echasnovski/mini.nvim",
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
    require("mini.jump2d").setup({
      -- Function producing jump spots (byte indexed) for a particular line.
      -- For more information see |MiniJump2d.start|.
      -- If `nil` (default) - use |MiniJump2d.default_spotter|
      spotter = nil,

      -- Characters used for labels of jump spots (in supplied order)
      labels = "abcdefghijklmnopqrstuvwxyz",

      -- Options for visual effects
      view = {
        -- Whether to dim lines with at least one jump spot
        dim = false,

        -- How many steps ahead to show. Set to big number to show all steps.
        n_steps_ahead = 0,
      },

      -- Which lines are used for computing spots
      allowed_lines = {
        blank = true, -- Blank line (not sent to spotter even if `true`)
        cursor_before = true, -- Lines before cursor line
        cursor_at = true, -- Cursor line
        cursor_after = true, -- Lines after cursor line
        fold = true, -- Start of fold (not sent to spotter even if `true`)
      },

      -- Which windows from current tabpage are used for visible lines
      allowed_windows = {
        current = true,
        not_current = true,
      },

      -- Functions to be executed at certain events
      hooks = {
        before_start = nil, -- Before jump start
        after_jump = nil, -- After jump was actually done
      },

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        start_jumping = "<CR>",
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
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "Toggle Git Diff Overlay",
    },
  },
}
