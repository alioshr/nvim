vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("vim.lsp.protocol.Methods.textDocument_completion") then
      vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }

      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

      vim.keymap.set("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = true,
  update_in_insert = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Configure diagnostics underline styles for error, warning and info
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, underdouble = true, sp = "#E06C75" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, underdouble = true, sp = "#E5C07B" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, underdouble = true, sp = "#61AFEF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, underdouble = true, sp = "#C678DD" })
