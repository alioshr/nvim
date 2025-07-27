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
            args = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
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
        format_on_save = {
          timeout_ms = 500,
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
