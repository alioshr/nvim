local M = {}

local function ensure_popup_float_session(cwd)
  vim.fn.system({ "tmux", "has-session", "-t", "popup-float" })
  if vim.v.shell_error ~= 0 then
    vim.fn.system({ "tmux", "new-session", "-d", "-s", "popup-float", "-c", cwd })
  end
end

-- Switch to popup-float session (create if needed), with Ctrl+Q to switch back
M.createFloatingTerminal = function()
  local cwd = vim.fn.getcwd()
  ensure_popup_float_session(cwd)
  -- Switch to popup-float session
  vim.fn.system({ "tmux", "switch-client", "-t", "popup-float" })
end

-- Factory function to create window name from window name and file name
M.createWindowName = function(windowName, fileName)
  return string.format("%s-%s", windowName, fileName)
end

-- Factory function to create tmux command with prefix, path, and suffix
M.createCommand = function(prefix, path, suffix)
  local parts = { prefix, vim.fn.shellescape(path) }
  if suffix and suffix ~= "" then
    parts[#parts + 1] = suffix
  end
  return table.concat(parts, " ")
end

-- Create a tmux window with a specific name and run a command
M.createWindowAndRunCommand = function(windowName, command)
  vim.fn.system({ "tmux", "new-window", "-t", "popup-float", "-n", windowName, command })
end

-- Combined function: create floating terminal, then create window and run command
M.runInFloatingTerminalWindow = function(windowName, command)
  -- First ensure the popup-float session exists (but don't show the popup)
  local cwd = vim.fn.getcwd()
  ensure_popup_float_session(cwd)

  -- Then create the window and run the command
  M.createWindowAndRunCommand(windowName, command)

  -- Finally show the floating terminal
  M.createFloatingTerminal()
end

return M
