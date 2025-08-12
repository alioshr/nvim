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
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                library = {
                  vim.fn.expand("$VIMRUNTIME/lua"),
                  vim.fn.stdpath("config") .. "/lua",
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                  "$XDG_DATA_HOME/nvim/lazy",
                },
              },
            },
          },
        },
        ts_ls = {
          on_attach = function(client)
            -- Disable the LSP's formatting capabilities to prevent conflicts with conform.nvim
            client.server_capabilities.documentFormattingProvider = false
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
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
          "stylua",
          "prettier",
        },
      })

      -- set and run lsp servers
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        lspconfig[server].setup(config)
      end
    end,
  },
}
