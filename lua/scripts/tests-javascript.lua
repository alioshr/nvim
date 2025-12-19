local tmux = require("scripts.tmux")
local utils = require("scripts.utils")

local M = {}

-- Test strategies singleton
local testStrategies = {
  vitest = {
    prefix = "npx vitest",
    suffix = "--watch",
    windowName = "Vitest",
  },
  jest = {
    prefix = "npx jest",
    suffix = "--watch",
    windowName = "Jest",
  },
  craco = {
    prefix = "npx craco test",
    suffix = "--watch",
    windowName = "Craco",
  },
}

-- Generic test runner function
local function runTest(strategy)
  local filePath = utils.get_current_file_path()
  local fileName = utils.get_current_file_name()

  if not filePath or filePath == "" then
    print("No file is currently open")
    return
  end

  -- Check if it's a test file
  if not (filePath:match("%.test%.") or filePath:match("%.spec%.")) then
    print("Current file is not a test file")
    return
  end

  local config = testStrategies[strategy]
  if not config then
    print("Unknown test strategy: " .. strategy)
    return
  end

  local command = tmux.createCommand(config.prefix, filePath, config.suffix)
  local windowName = tmux.createWindowName(config.windowName, fileName)

  tmux.runInFloatingTerminalWindow(windowName, command)
end

-- Exported test runner methods
M.runVitestTest = function()
  runTest("vitest")
end

M.runJestTest = function()
  runTest("jest")
end

M.runCracoTest = function()
  runTest("craco")
end

return M
