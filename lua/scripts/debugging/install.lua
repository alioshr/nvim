local M = {}

local function ensure_package_installed(package_name)
  local ok_mason, mason = pcall(require, "mason")
  if ok_mason then
    mason.setup()
  end

  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return
  end

  local function install_if_missing()
    if not registry.has_package(package_name) then
      vim.schedule(function()
        vim.notify("mason-registry: missing package " .. package_name, vim.log.levels.WARN)
      end)
      return
    end

    local pkg = registry.get_package(package_name)
    if pkg:is_installed() or pkg:is_installing() then
      return
    end

    pkg:install()
    vim.schedule(function()
      vim.notify("Installing " .. package_name .. " via Mason...", vim.log.levels.INFO)
    end)
  end

  if registry.refresh then
    registry.refresh(install_if_missing)
    return
  end

  install_if_missing()
end

---@param debug_config table
function M.ensure_js_debug_adapter(debug_config)
  if vim.uv.fs_stat(debug_config.adapter_entry) then
    return
  end

  ensure_package_installed("js-debug-adapter")
end

return M
