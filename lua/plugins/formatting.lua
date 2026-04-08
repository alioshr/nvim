return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      local prettier_configs = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.mjs",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        ".prettierrc.toml",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.mjs",
      }
      local biome_configs = { "biome.json", "biome.jsonc" }

      --- Returns { "biome" }, { "prettier" }, or {} based on project config
      ---@param bufnr number
      ---@return string[]
      local function web_formatter(bufnr)
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if vim.fs.find(biome_configs, { path = filepath, upward = true })[1] then
          return { "biome" }
        end
        if vim.fs.find(prettier_configs, { path = filepath, upward = true })[1] then
          return { "prettier" }
        end
        return {}
      end

      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = web_formatter,
          javascriptreact = web_formatter,
          typescript = web_formatter,
          typescriptreact = web_formatter,
          json = web_formatter,
          jsonc = web_formatter,
          graphql = web_formatter,
          yaml = web_formatter,
          yml = web_formatter,
        },
        formatters = {
          stylua = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/stylua"),
            prepend_args = { "--config-path", vim.fn.expand("~/.config/nvim/.stylua.toml") },
          },
          prettier = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/prettier"),
            -- Use project config if available, fallback to global config
            prepend_args = function(ctx)
              local project_config =
                vim.fs.find(prettier_configs, { path = ctx.filename, upward = true })[1]
              if not project_config then
                return { "--config", vim.fn.expand("~/.config/nvim/.prettierrc") }
              end
              return {}
            end,
          },
          biome = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/biome"),
          },
        },
        default_format_opts = {
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
