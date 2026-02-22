local M = {}

---@param dap table
---@param debug_config table
function M.setup(dap, debug_config)
  local js_debug_entry = debug_config.adapter_entry

  if not vim.uv.fs_stat(js_debug_entry) then
    vim.schedule(function()
      vim.notify(
        "nvim-dap: js-debug-adapter not found. Install it via :MasonInstall js-debug-adapter",
        vim.log.levels.WARN
      )
    end)
  end

  for _, adapter_type in ipairs({ "node", "chrome" }) do
    local pwa_type = "pwa-" .. adapter_type

    dap.adapters[pwa_type] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = debug_config.node_command,
        args = { js_debug_entry, "${port}" },
      },
    }

    dap.adapters[adapter_type] = function(cb, config)
      local native_adapter = dap.adapters[pwa_type]
      config.type = pwa_type

      if type(native_adapter) == "function" then
        native_adapter(cb, config)
        return
      end

      cb(native_adapter)
    end
  end

  -- Backwards compatibility for launch.json entries that still specify "msedge".
  dap.adapters.msedge = function(cb, config)
    local chrome_adapter = dap.adapters.chrome
    config.type = "pwa-chrome"

    if type(chrome_adapter) == "function" then
      chrome_adapter(cb, config)
      return
    end

    cb(chrome_adapter)
  end
end

return M
