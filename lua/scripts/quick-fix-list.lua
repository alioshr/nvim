local function replaceInQuickFixList()
  vim.ui.input({ prompt = "Search for: " }, function(old)
    if not old or old == "" then
      return
    end

    vim.ui.input({ prompt = "Replace with: " }, function(new)
      if not new then
        return
      end

      local cmd = string.format(":cfdo %%s/%s/%s/gc | update", old, new)
      vim.api.nvim_feedkeys(cmd, "n", false)
    end)
  end)
end

return {
  replaceInQuickFixList = replaceInQuickFixList,
}
