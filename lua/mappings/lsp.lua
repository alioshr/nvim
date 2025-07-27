vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion

    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    -- Commented out as we are using snacks.picker for references
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

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
    end, opts)

    -- open the diagnostic window under the cursor in a flat window
    vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.open_float({
        scope = "line",
        border = "rounded",
        source = "always",
      })
    end, opts)
  end,
})
