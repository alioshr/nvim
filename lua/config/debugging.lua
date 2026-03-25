local M = {}

M.js = {
  adapter_entry = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
  node_command = "node",
  browsers = {
    arc_path = "/Applications/Arc.app/Contents/MacOS/Arc",
    chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    chrome_user_data_dir = os.getenv("HOME") .. "/.chrome-debug-profile",
    default_url = "http://localhost:3000",
    attach_port = 9222,
    smart_step = true,
    skip_files = {
      "<node_internals>/**",
      "**/node_modules/**",
      "webpack://*/node_modules/**",
    },
    source_map_path_overrides = {
      ["webpack:///./*"] = "${webRoot}/*",
      ["webpack:///*"] = "${webRoot}/*",
      ["webpack:///src/*"] = "${webRoot}/src/*",
      ["vite:///*"] = "${webRoot}/*",
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
}

local colors_set = false

local function sign_column_background()
  local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })
  local bg = "NONE"
  local ctermbg = "NONE"

  if sign_column_hl.bg then
    bg = string.format("#%06x", sign_column_hl.bg)
  end

  if sign_column_hl.ctermbg then
    ctermbg = sign_column_hl.ctermbg
  end

  return bg, ctermbg
end

local function apply_dap_colors()
  if colors_set then
    return
  end

  local sign_column_bg, sign_column_ctermbg = sign_column_background()

  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#e3be44", bg = sign_column_bg, ctermbg = sign_column_ctermbg })
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#e2f1bc", ctermbg = "Green" })
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

function M.setup_signs()
  local group = vim.api.nvim_create_augroup("dap_colors", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    pattern = "*",
    desc = "Set DAP marker colors and prevent color theme from resetting them",
    callback = function()
      colors_set = false
      apply_dap_colors()
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    pattern = "*",
    desc = "Ensure DAP colors are set",
    callback = apply_dap_colors,
  })

  apply_dap_colors()
end

M.setup_signs()

return M
