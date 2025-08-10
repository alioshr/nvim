vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = true,
  update_in_insert = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

-- Configure diagnostics underline styles for error, warning and info
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, underdouble = true, sp = "#E06C75" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, underdouble = true, sp = "#E5C07B" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, underdouble = true, sp = "#61AFEF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, underdouble = true, sp = "#C678DD" })
