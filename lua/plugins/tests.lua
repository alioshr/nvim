return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    -- Jest is not working: https://github.com/nvim-neotest/neotest-jest/issues/99
    -- "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>tr", "<cmd>Neotest run<cr>", desc = "Tests: Run" },
    { "<leader>ti", "<cmd>Neotest output<cr>", desc = "Tests: Show output" },
    { "<leader>ts", "<cmd>Neotest summary<cr>", desc = "Tests: Show summary" },
    { "<leader>ta", '<cmd>lua require("neotest").run.run({ suite = true })<cr>', desc = "Tests: Run all" },
    {
      "<leader>tU",
      function()
        local current_file = vim.fn.expand("%:p")
        if current_file:match("%.test%.") or current_file:match("%.spec%.") then
          -- Detect if we should use jest or vitest
          local cwd = vim.fn.getcwd()
          local vitest_config = vim.fn.glob(cwd .. "/vitest.config.*")
          local jest_config = vim.fn.glob(cwd .. "/jest.config.*")

          if vitest_config ~= "" then
            require("neotest").run.run({
              vitestCommand = "npx vitest " .. current_file .. " -u",
            })
          elseif jest_config ~= "" then
            require("neotest").run.run({
              jestCommand = "npx jest " .. current_file .. " -u",
            })
          else
            -- Fallback: check package.json for dependencies
            local package_json = vim.fn.readfile(cwd .. "/package.json")
            if package_json and #package_json > 0 then
              local content = table.concat(package_json, "\n")
              if content:match('"vitest"') then
                require("neotest").run.run({
                  vitestCommand = "npx vitest " .. current_file .. " -u",
                })
              elseif content:match('"jest"') then
                require("neotest").run.run({
                  jestCommand = "npx jest " .. current_file .. " -u",
                })
              else
                print("Could not detect test framework (jest/vitest)")
              end
            else
              print("Could not detect test framework (jest/vitest)")
            end
          end
        else
          print("Not a test file")
        end
      end,
      desc = "Tests: Run current file with update snapshots",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
        -- Jest is not working: https://github.com/nvim-neotest/neotest-jest/issues/99
        -- require("neotest-jest")({
        --   jestCommand = "npm test --",
        --   jestConfigFile = "custom.jest.config.ts",
        --   jest_test_discovery = true,
        --   env = { CI = true },
        --   cwd = function(path)
        --     return vim.fn.getcwd()
        --   end,
        -- }),
      },
      discovery = {
        enabled = false,
      },
    })
  end,
}
