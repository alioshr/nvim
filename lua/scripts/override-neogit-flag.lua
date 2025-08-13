-- Enhanced function to override neogit switch flags
---@param popup The popup object from neogit builder
---@param switches Array of switch names to modify (e.g., {"no-verify", "force"})
---@param options Optional configuration { enabled = boolean, persisted = boolean }
local function overrideNeogitFlags(popup, switches, options)
  -- Default options (similar to JS default parameters)
  options = options or {}

  local config = {
    persisted = true,
    enabled = false, -- Default to false instead of nil
  }

  -- Merge user options (only iterates over non-nil values in options)
  for key, value in pairs(options) do
    config[key] = value
  end

  -- Convert switches to a lookup table for O(1) performance (like Set in JS)
  local switchSet = {}
  for _, switch in ipairs(switches) do
    switchSet[switch] = true
  end

  -- Iterate and modify matching switches - straightforward assignment
  for _, arg in pairs(popup.state.args) do
    if arg.type == "switch" and switchSet[arg.cli] then
      arg.persisted = config.persisted
      arg.enabled = config.enabled
    end
  end
end

local function makePersistent(popup, switches)
  return overrideNeogitFlags(popup, switches, { persisted = true })
end

local function enableAndPersist(popup, switches)
  return overrideNeogitFlags(popup, switches, { enabled = true, persisted = true })
end

return {
  overrideNeogitFlags = overrideNeogitFlags,
  makePersistent = makePersistent,
  enableAndPersist = enableAndPersist,
}
