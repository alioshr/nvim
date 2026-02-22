local M = {}

local debug_config = require("config.debugging").js

---@param dap table
function M.setup(dap)
  require("scripts.debugging.install").ensure_js_debug_adapter(debug_config)
  require("scripts.debugging.adapters.js").setup(dap, debug_config)
  require("scripts.debugging.configurations.js").setup(dap, debug_config)

  dap.listeners.on_config.codex_dap_convert_args = function(config)
    local converted = {}

    for key, value in pairs(vim.deepcopy(config)) do
      if key == "args" and type(value) == "string" then
        converted[key] = require("dap.utils").splitstr(value)
      else
        converted[key] = value
      end
    end

    return converted
  end

  pcall(vim.api.nvim_del_user_command, "DebugHealth")
  vim.api.nvim_create_user_command("DebugHealth", function()
    require("scripts.debugging.health").check(debug_config, dap)
  end, { desc = "Show JS/TS debugging setup health" })
end

return M
