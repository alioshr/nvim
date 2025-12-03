return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    ---@module 'dap'
    local dap = require("dap")
    ---@module 'dapui'ª
    local dapui = require("dapui")

    dap.defaults.fallback.exception_breakpoints = { "uncaught" }

    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
      },
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 50,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    })

    -- Open and close dap-ui automatically
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Keybindings for DAP
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Debbuger: Toggle breakpoint" })
    vim.keymap.set("n", "<Leader>dB", function()
      local condition = vim.fn.input("Breakpoint condition (optional): ")
      local hit_condition = vim.fn.input("Hit count (optional): ")

      -- Convert empty strings to nil
      condition = condition ~= "" and condition or nil
      hit_condition = hit_condition ~= "" and hit_condition or nil

      require("dap").toggle_breakpoint(condition, hit_condition)
    end, { desc = "Debbuger: Set conditional breakpoint" })
    vim.keymap.set("n", "<Leader>dbc", dap.clear_breakpoints, { desc = "Debbuger: Clear all breakpoints" })
    vim.keymap.set("n", "<Leader>dbl", dap.list_breakpoints, { desc = "Debbuger: Clear all breakpoints" })
    vim.keymap.set("n", "<Leader>do", dapui.toggle, { desc = "Debbuger: Toggle DAP UI" })
    vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Debbuger: Continue/Launch" })

    -- Language-specific debugging configuration
    require("scripts.debugging.js").setup(dap)
  end,
}
