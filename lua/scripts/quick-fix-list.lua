local function escape_substitute_pattern(value, delimiter)
  local escaped = value:gsub("\\", "\\\\"):gsub(delimiter, "\\" .. delimiter)
  return "\\V" .. escaped
end

local function escape_substitute_replacement(value, delimiter)
  return value:gsub("\\", "\\\\"):gsub("&", "\\&"):gsub(delimiter, "\\" .. delimiter)
end

local function replaceInQuickFixList(options)
  options = options or {}
  local confirm_each_match = options.confirm_each_match ~= false

  vim.ui.input({ prompt = "Search for: " }, function(old)
    if not old or old == "" then
      return
    end

    vim.ui.input({ prompt = "Replace with: " }, function(new)
      if not new then
        return
      end

      local delimiter = "#"
      local escaped_old = escape_substitute_pattern(old, delimiter)
      local escaped_new = escape_substitute_replacement(new, delimiter)
      local flags = confirm_each_match and "gce" or "ge"

      if not confirm_each_match then
        local choice = vim.fn.confirm(
          string.format("Replace all in quickfix files?\n\n%s\n->\n%s", old, new),
          "&Yes\n&No",
          2
        )
        if choice ~= 1 then
          return
        end
      end

      local ok, err = pcall(function()
        vim.cmd(string.format("cfdo %%s%s%s%s%s%s%s", delimiter, escaped_old, delimiter, escaped_new, delimiter, flags))
        vim.cmd("cfdo update")
      end)

      if not ok then
        vim.notify("Quickfix replace failed: " .. tostring(err), vim.log.levels.ERROR)
      end
    end)
  end)
end

return {
  replaceInQuickFixList = replaceInQuickFixList,
  replaceInQuickFixListBatch = function()
    replaceInQuickFixList({ confirm_each_match = false })
  end,
}
