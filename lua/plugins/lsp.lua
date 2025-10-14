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
        eslint = {
          on_init = function(client)
            local eslint_fix = require("scripts.eslintFixAll")
            vim.api.nvim_create_user_command("EslintFixAll", function()
              eslint_fix.fix_all({ client = client, sync = true })
            end, { desc = "Fix all eslint problems for this buffer" })
          end,
        },
        taplo = {},
        yamlls = {},
        jsonls = {},
        tailwindcss = {},
      },
    },
    config = function(_, opts)
      require("mason").setup()

      -- keep this all disabled to avoid duplicate lsp clients from running https://www.youtube.com/watch?v=p2hNnoMeI4o
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        automatic_setup = false,
        automatic_enable = false,
        handlers = nil,
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "taplo",
          "prettier",
          "lua_ls",
          "eslint",
          "ts_ls",
        },
      })

      -- set and run lsp servers using new vim.lsp.config API
      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
      end

      -- enable all configured servers
      vim.lsp.enable(vim.tbl_keys(opts.servers))
    end,
  },
}
