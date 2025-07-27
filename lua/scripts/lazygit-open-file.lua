return function(filename, line)
  if not filename then
    return
  end

  -- Try to close any floating LazyGit window safely
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
    if ok then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("lazygit") then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end

  -- Open the file
  vim.cmd("edit " .. vim.fn.fnameescape(filename))

  -- Jump to line if provided
  line = tonumber(line)
  if line and line > 0 then
    vim.fn.cursor({ line, 1 })
  end
end
