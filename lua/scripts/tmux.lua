local M = {}

-- Factory function to create tmux floating terminal
M.createFloatingTerminal = function()
  local cwd = vim.fn.getcwd()
  vim.fn.system(
    string.format(
      'tmux display-popup -E -b single -s fg=#545464,bg=#f2ecbc -S fg=colour7,bg=#f2ecbc -h 100%% -w 100%% -x 0 -y 0 -d "%s" "tmux new-session -A -s popup-float -c \\"%s\\" \\; bind-key -n C-q detach-client \\; bind-key -n C-d kill-session"',
      cwd,
      cwd
    )
  )
end

-- Factory function to create window name from window name and file name
M.createWindowName = function(windowName, fileName)
  return string.format("%s-%s", windowName, fileName)
end

-- Factory function to create tmux command with prefix, path, and suffix
M.createCommand = function(prefix, path, suffix)
  return string.format("%s %s %s", prefix, path, suffix)
end

-- Create a tmux window with a specific name and run a command
M.createWindowAndRunCommand = function(windowName, command)
  local tmuxCommand = string.format('tmux new-window -t popup-float -n "%s" "%s"', windowName, command)
  vim.fn.system(tmuxCommand)
end

-- Combined function: create floating terminal, then create window and run command
M.runInFloatingTerminalWindow = function(windowName, command)
  -- First ensure the popup-float session exists (but don't show the popup)
  local cwd = vim.fn.getcwd()
  vim.fn.system(string.format('tmux new-session -d -A -s popup-float -c "%s"', cwd))

  -- Then create the window and run the command
  M.createWindowAndRunCommand(windowName, command)

  -- Finally show the floating terminal
  M.createFloatingTerminal()
end

return M
