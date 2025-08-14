return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
    },
    config = function()
      vim.cmd.colorscheme("tokyonight")
      -- Override unused variable colors
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#8a92b3" })
      vim.api.nvim_set_hl(0, "@variable.unused", { fg = "#8a92b3" })
      vim.api.nvim_set_hl(0, "@parameter.unused", { fg = "#8a92b3" })
    end,
  },
}
