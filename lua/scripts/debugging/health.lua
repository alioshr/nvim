local M = {}

---@param debug_config table
---@param dap table
function M.check(debug_config, dap)
  local lines = {}
  local issues = 0

  local node_ok = vim.fn.executable(debug_config.node_command) == 1
  lines[#lines + 1] = string.format("[%-4s] node (%s)", node_ok and "OK" or "FAIL", debug_config.node_command)
  if not node_ok then
    issues = issues + 1
  end

  local adapter_ok = vim.uv.fs_stat(debug_config.adapter_entry) ~= nil
  lines[#lines + 1] = string.format("[%-4s] js-debug-adapter (%s)", adapter_ok and "OK" or "FAIL", debug_config.adapter_entry)
  if not adapter_ok then
    issues = issues + 1
  end

  local arc_ok = vim.fn.executable(debug_config.browsers.arc_path) == 1
  lines[#lines + 1] = string.format("[%-4s] arc (%s)", arc_ok and "OK" or "WARN", debug_config.browsers.arc_path)

  local has_pwa_node = dap.adapters["pwa-node"] ~= nil
  lines[#lines + 1] = string.format("[%-4s] dap adapter pwa-node", has_pwa_node and "OK" or "FAIL")
  if not has_pwa_node then
    issues = issues + 1
  end

  local has_pwa_chrome = dap.adapters["pwa-chrome"] ~= nil
  lines[#lines + 1] = string.format("[%-4s] dap adapter pwa-chrome", has_pwa_chrome and "OK" or "FAIL")
  if not has_pwa_chrome then
    issues = issues + 1
  end

  local level = issues == 0 and vim.log.levels.INFO or vim.log.levels.WARN
  vim.notify(table.concat(lines, "\n"), level, { title = "DebugHealth" })
end

return M
