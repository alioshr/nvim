-- augroup to be able to trigger the autocommand explicitly for the first time
vim.api.nvim_create_augroup("dap_colors", {})

local colors_set = false

local function set_dap_colors()
  if colors_set then
    return
  end

  -- Reuse current SignColumn background (except for DapStoppedLine)
  local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })

  -- Better background color handling
  local sign_column_bg = "NONE"
  local sign_column_ctermbg = "NONE"

  if sign_column_hl.bg then
    sign_column_bg = string.format("#%06x", sign_column_hl.bg)
  end

  if sign_column_hl.ctermbg then
    sign_column_ctermbg = sign_column_hl.ctermbg
  end

  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#e3be44", bg = sign_column_bg, ctermbg = sign_column_ctermbg })
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#53553b", ctermbg = "Green" })
  vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#c23127", bg = sign_column_bg, ctermbg = sign_column_ctermbg })
  vim.api.nvim_set_hl(
    0,
    "DapBreakpointCondition",
    { fg = "#8444e3", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
  )
  vim.api.nvim_set_hl(
    0,
    "DapBreakpointRejected",
    { fg = "#888ca6", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
  )
  vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = sign_column_bg, ctermbg = sign_column_ctermbg })

  -- Redefine DAP signs to use our highlight groups (this is the key fix!)
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
  )
  vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "●", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
  )
  vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "DapLogPoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

  colors_set = true
end

-- Reset flag on colorscheme change so colors get reapplied
local function reset_and_set_colors()
  colors_set = false
  set_dap_colors()
end

-- autocmd to enforce colors settings on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "dap_colors",
  pattern = "*",
  desc = "Set DAP marker colors and prevent color theme from resetting them",
  callback = reset_and_set_colors,
})

-- Also set once on VimEnter in case we missed the colorscheme event
vim.api.nvim_create_autocmd("VimEnter", {
  group = "dap_colors",
  pattern = "*",
  desc = "Ensure DAP colors are set",
  callback = set_dap_colors,
})

-- executing the settings explicitly for the first time
set_dap_colors()
