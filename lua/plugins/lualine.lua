return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local utils = require("scripts.utils")

      require("lualine").setup({
        options = {
          theme = "kanagawa",
        },
        sections = {
          lualine_a = {
            {
              utils.get_cwd_basename,
              icon = "",
              color = { gui = "bold" },
            },
          },
          lualine_c = { {
            "filename",
            path = 1,
          } },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_x = { "filetype" },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_workspace_diagnostic" },
            },
          },
          lualine_z = {},
        },
      })
    end,
  },
}
