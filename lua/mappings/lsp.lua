vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion

    vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show hover information" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code actions" })

    vim.keymap.set("n", "<leader>f", function()
      -- First run ESLint fixes if available
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.name == "eslint" then
          vim.cmd("EslintFixAll")
          break
        end
      end
      -- Then run conform formatting
      require("conform").format({ async = true, lsp_fallback = true })
    end, { buffer = ev.buf, desc = "Format with ESLint and conform" })

    -- open the diagnostic window under the cursor in a flat window
    vim.keymap.set("n", "<leader>df", function()
      vim.diagnostic.open_float({
        scope = "line",
        border = "rounded",
        source = true,
      })
    end, { buffer = ev.buf, desc = "Show line diagnostics" })
  end,
})
