return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig",
      "artemave/workspace-diagnostics.nvim",
    },
    opts = {
      servers = {
        lua_ls = {
          on_attach = function(client)
            -- Disable the LSP's formatting capabilities to prevent conflicts with conform.nvim
            client.server_capabilities.documentFormattingProvider = false
          end,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        ts_ls = {
          on_attach = function(client)
            -- Disable the LSP's formatting capabilities to prevent conflicts with conform.nvim
            client.server_capabilities.documentFormattingProvider = false
            require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
          end,
        },
        eslint = {},
        tailwindcss = {},
      },
    },
    config = function(_, opts)
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "eslint", "ts_ls" },
      })
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", -- Lua formatter
          "prettier", -- JS/TS/JSON formatter
        },
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("eslint")
      vim.lsp.enable("ts_ls")

      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        lspconfig[server].setup(config)
      end
    end,
  },
}
