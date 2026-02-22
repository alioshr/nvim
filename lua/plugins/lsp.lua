return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig",
      "artemave/workspace-diagnostics.nvim",
    },
    opts = function()
      local languages = require("config.languages")
      local server_filetypes = languages.lsp_filetypes_by_server()

      if vim.fn.exists(":EslintFixAll") == 0 then
        local eslint_fix = require("scripts.eslintFixAll")
        vim.api.nvim_create_user_command("EslintFixAll", function()
          eslint_fix.fix_all({ sync = true })
        end, { desc = "Fix all eslint problems for this buffer" })
      end

      local servers = {
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
        taplo = {},
        yamlls = {},
        jsonls = {},
      }

      for server, filetypes in pairs(server_filetypes) do
        if servers[server] then
          servers[server].filetypes = filetypes
        end
      end

      return {
        servers = servers,
        mason_extra_tools = {
          "stylua",
          "prettier",
        },
        mason_lsp_packages = languages.mason_lsp_packages(),
      }
    end,
    config = function(_, opts)
      local function uniq(list)
        local seen = {}
        local out = {}
        for _, value in ipairs(list) do
          if value and value ~= "" and not seen[value] then
            seen[value] = true
            out[#out + 1] = value
          end
        end
        return out
      end

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
        ensure_installed = uniq(vim.list_extend(
          vim.deepcopy(opts.mason_extra_tools or {}),
          vim.deepcopy(opts.mason_lsp_packages or {})
        )),
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
