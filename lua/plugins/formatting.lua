return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          graphql = { "prettier" },
        },
        formatters = {
          stylua = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/stylua"),
            prepend_args = { "--config-path", vim.fn.expand("~/.config/nvim/.stylua.toml") },
          },
          prettier = {
            require_cwd = true,
            -- Ensure it finds your project's prettier config
            condition = function(ctx)
              return vim.fs.find(
                { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js" },
                { path = ctx.filename, upward = true }
              )[1]
            end,
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
