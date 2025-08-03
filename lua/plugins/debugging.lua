return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "igorlfs/nvim-dap-view",
    },
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue debugging" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step into" },
      { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step over" },
      { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step out" },
      { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover variables",
      },
      {
        "<leader>ds",
        function()
          require("dap.ui.widgets").scopes()
        end,
        desc = "Show scopes",
      },
      { "<leader>dv", "<cmd>DapViewOpen<cr>", desc = "Open DAP View" },
      {
        "<leader>dw",
        "<cmd>DapViewWatch<cr>",
        desc = "Watch word under cursor",
      },
      { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate debugging" },
    },
    config = function()
      local dap = require("dap")

      require("dap-view").setup()

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      dap.adapters["local-lua"] = {
        type = "executable",
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension/extension/debugAdapter.js",
        },
        enrich_config = function(config, on_config)
          if not config["extensionPath"] then
            local c = vim.deepcopy(config)
            c.extensionPath = vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension/"
            on_config(c)
          else
            on_config(config)
          end
        end,
      }

      local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Debbuger (JS/TS/TSX)",
            runtimeExecutable = "npx",
            runtimeArgs = { "tsx", "${file}" },
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch TypeScript file (ts-node)",
            runtimeExecutable = "npx",
            runtimeArgs = { "ts-node", "${file}" },
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
        }
      end

      dap.configurations.lua = {
        {
          type = "local-lua",
          request = "launch",
          name = "Debug current file (lua)",
          cwd = "${workspaceFolder}",
          program = {
            lua = "lua",
            file = "${file}",
          },
          args = {},
        },
        {
          type = "local-lua",
          request = "launch",
          name = "Debug current file (nvim)",
          cwd = "${workspaceFolder}",
          program = {
            lua = "nvim",
            file = "${file}",
          },
          args = { "--headless", "-u", "NONE", "-l" },
        },
      }
    end,
  },
}
