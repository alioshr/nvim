local resume = require("snacks.picker.resume")

-- Sources that use live/streaming finders and should not cache items
local live_sources = {
  grep = true,
  grep_word = true,
  files = true,
  git_files = true,
  git_status = true,
  git_log = true,
  git_branches = true,
  git_stash = true,
}

-- Patch resume.add to keep multiple entries per source
local orig_add = resume.add
resume.add = function(picker)
  orig_add(picker)
  local source = picker.opts.source or "custom"
  if source == "custom" then
    resume.state[source] = nil
    return
  end
  local state = resume.state[source]
  if not state then
    return
  end
  -- Clear cached items for live sources so they re-run the finder
  if live_sources[source] then
    state.items = nil
  end
  -- For LSP pickers, grab the symbol name from the word under cursor
  if source:find("^lsp_") and not state._symbol then
    state._symbol = vim.fn.expand("<cword>")
  end
  local search = state.filter and state.filter.search or ""
  local pattern = state.filter and state.filter.pattern or ""
  local symbol = state._symbol or ""
  local key = source .. "::" .. search .. "::" .. pattern .. "::" .. symbol
  local copy = vim.deepcopy(state)
  if live_sources[source] then
    copy.items = nil
  end
  resume.state[key] = copy
end

local function picker_history()
  local states = {}
  local seen_keys = {}

  for key, state in pairs(resume.state) do
    local source = key:match("^(.-)::") or key
    local is_unique_key = key:find("::") ~= nil

    if is_unique_key then
      seen_keys[source] = true
      local search = state.filter and state.filter.search or ""
      local pattern = state.filter and state.filter.pattern or ""
      local symbol = state._symbol or ""
      states[#states + 1] = {
        source = source,
        search = search,
        pattern = pattern,
        symbol = symbol,
        added = state.added,
        state = state,
      }
    end
  end

  for key, state in pairs(resume.state) do
    if not key:find("::") and not seen_keys[key] and key ~= "custom" then
      states[#states + 1] = {
        source = key,
        search = state.filter and state.filter.search or "",
        pattern = state.filter and state.filter.pattern or "",
        added = state.added,
        state = state,
      }
    end
  end

  table.sort(states, function(a, b)
    return a.added > b.added
  end)

  if #states == 0 then
    vim.notify("No picker history", vim.log.levels.INFO)
    return
  end

  local items = {}
  for idx, entry in ipairs(states) do
    local display = entry.search ~= "" and entry.search or entry.pattern ~= "" and entry.pattern or entry.symbol or ""
    items[#items + 1] = {
      idx = idx,
      score = 1000 + #states - idx,
      text = entry.source .. " " .. display,
      source = entry.source,
      display = display,
      state = entry.state,
    }
  end

  Snacks.picker.pick({
    title = "Picker History",
    items = items,
    format = function(item)
      local ret = {}
      ret[#ret + 1] = { item.source, "SnacksPickerLabel" }
      if item.display and item.display ~= "" then
        ret[#ret + 1] = { "  |  ", "Comment" }
        ret[#ret + 1] = { item.display, "String" }
      end
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      if item and item.state then
        resume._resume(item.state)
      end
    end,
  })
end

return picker_history
