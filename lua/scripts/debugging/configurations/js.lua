local M = {}

local function prompt_url(default_url)
  local url = vim.fn.input("Enter URL: ", default_url)
  if url == nil or url == "" then
    return nil
  end
  return url
end

---@param debug_config table
local function browser_launch_configuration(debug_config)
  local config = {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Arc (nvim-dap)",
    url = function()
      return prompt_url(debug_config.browsers.default_url)
    end,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    smartStep = debug_config.browsers.smart_step,
    skipFiles = debug_config.browsers.skip_files,
    sourceMapPathOverrides = debug_config.browsers.source_map_path_overrides,
  }

  if vim.fn.executable(debug_config.browsers.arc_path) == 1 then
    config.runtimeExecutable = debug_config.browsers.arc_path
  else
    config.name = "Launch Chrome (nvim-dap)"
  end

  return config
end

---@param debug_config table
local function browser_attach_configuration(debug_config)
  return {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach Arc (port " .. debug_config.browsers.attach_port .. ") (nvim-dap)",
    port = debug_config.browsers.attach_port,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    smartStep = debug_config.browsers.smart_step,
    skipFiles = debug_config.browsers.skip_files,
    sourceMapPathOverrides = debug_config.browsers.source_map_path_overrides,
  }
end

---@param dap table
---@param debug_config table
function M.setup(dap, debug_config)
  local browser_launch = browser_launch_configuration(debug_config)
  local browser_attach = browser_attach_configuration(debug_config)

  for _, filetype in ipairs(debug_config.filetypes) do
    dap.configurations[filetype] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file using Node.js (nvim-dap)",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to process using Node.js (nvim-dap)",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file using Node.js with ts-node/register (nvim-dap)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeArgs = { "-r", "ts-node/register" },
      },
      vim.deepcopy(browser_launch),
      vim.deepcopy(browser_attach),
    }
  end
end

return M
