-- Configure diagnostics underline styles for error, warning and info
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#E06C75" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#E5C07B" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#61AFEF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#C678DD" })
