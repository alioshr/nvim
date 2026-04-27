local LINTERS = {
  eslint = function()
    vim.cmd("EslintFixAll")
  end,
  biome = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "biome" })[1]
    if not client then
      return
    end
    local params = {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
      range = {
        start = { line = 0, character = 0 },
        ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
      },
      context = {
        diagnostics = vim.diagnostic.get(bufnr),
        only = { "source.fixAll.biome", "source.organizeImports.biome" },
      },
    }
    local result = client:request_sync("textDocument/codeAction", params, 5000, bufnr)
    if not result or not result.result then
      return
    end
    for _, action in ipairs(result.result) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding or "utf-16")
      end
      if action.command then
        client:exec_cmd(action.command, { bufnr = bufnr })
      end
    end
  end,
  oxlint = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "oxlint" })[1]
    if not client then
      return
    end
    client:exec_cmd({
      title = "Apply Oxlint automatic fixes",
      command = "oxc.fixAll",
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, { bufnr = bufnr })
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
