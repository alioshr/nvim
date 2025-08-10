local LINTERS = {
  eslint = function()
    vim.cmd("EslintFixAll")
  end,
}

-- Runs client fixes, then formats the buffer using conform.nvim
---@param callback function to call after formatting
local function fixAndFormat(callback)
  -- First run linter fixes if available
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    local lint = LINTERS[client.name]

    if lint then
      lint()
      break
    end
  end
  -- Then run conform formatting with callback
  require("conform").format({
    async = true,
    lsp_fallback = true,
  }, callback)
end

return {
  fixAndFormat = fixAndFormat,
}
