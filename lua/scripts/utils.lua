local M = {}

M.get_current_file_name = function()
  local full_path = vim.fn.expand("%:p")
  return vim.fn.fnamemodify(full_path, ":t:r")
end

M.get_current_file_path = function()
  return vim.fn.expand("%:.")
end

M.get_current_file_abs_path = function()
  return vim.fn.expand("%:p")
end

M.get_cwd_path = function()
  return vim.fn.getcwd()
end

M.get_cwd_basename = function()
  return vim.fn.fnamemodify(M.get_cwd_path(), ":t")
end

return M
