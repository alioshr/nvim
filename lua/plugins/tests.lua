return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>tr", "<cmd>Neotest run<cr>", desc = "Run tests" },
    { "<leader>ti", "<cmd>Neotest output<cr>", desc = "Show test output" },
    { "<leader>ts", "<cmd>Neotest summary<cr>", desc = "Show test summary" },
    { "<leader>ta", '<cmd>lua require("neotest").run.run({ suite = true })<cr>', desc = "Run all tests" },
    {
      "<leader>tU",
      function()
        local current_file = vim.fn.expand("%:p")
        if current_file:match("%.test%.") or current_file:match("%.spec%.") then
          require("neotest").run.run({
            vitestCommand = "npx vitest " .. current_file .. " -u",
          })
        else
          print("Not a test file")
        end
      end,
      desc = "Run current test file with update snapshots",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
      },
      discovery = {
        enabled = false,
      },
    })
  end,
}
