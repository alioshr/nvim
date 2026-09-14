-- Shim for Neogit's codediff integration, which still builds the old
-- codediff SessionConfig (mode/explorer_data/original_path). codediff now
-- expects panel = { name, data } and Path refs in original/modified.
-- Upstream: https://github.com/NeogitOrg/neogit/issues/2008
-- The shim is a no-op for configs already in the new shape, so it keeps
-- working once Neogit is fixed and can then be removed.
local M = {}

local LEGACY_KEYS = { "mode", "explorer_data", "history_data", "original_path", "modified_path" }

local function is_legacy(session_config)
  for _, key in ipairs(LEGACY_KEYS) do
    if session_config[key] ~= nil then
      return true
    end
  end
  return false
end

---Convert a legacy session config into the current SessionConfig shape (in place).
---@param session_config table
---@param path table codediff.core.path
---@return table
function M.normalize(session_config, path)
  if type(session_config) ~= "table" or not is_legacy(session_config) then
    return session_config
  end

  local mode = session_config.mode
  if session_config.panel == nil then
    if mode == "explorer" then
      session_config.panel = { name = "explorer", data = session_config.explorer_data or {} }
    elseif mode == "history" then
      session_config.panel = { name = "history", data = session_config.history_data or {} }
    end
  end

  local root = session_config.git_root
  if session_config.original == nil then
    session_config.original = path.make_ref(session_config.original_path, root)
  end
  if session_config.modified == nil then
    session_config.modified = path.make_ref(session_config.modified_path, root)
  end

  for _, key in ipairs(LEGACY_KEYS) do
    session_config[key] = nil
  end

  return session_config
end

---Wrap codediff.ui.view.create so legacy callers keep working. Idempotent.
function M.install()
  local ok_view, view = pcall(require, "codediff.ui.view")
  local ok_path, path = pcall(require, "codediff.core.path")
  if not (ok_view and ok_path) or type(view.create) ~= "function" or view._legacy_session_shim then
    return
  end

  local create = view.create
  view.create = function(session_config, ...)
    return create(M.normalize(session_config, path), ...)
  end
  view._legacy_session_shim = true
end

return M
