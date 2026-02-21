return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local utils = require("scripts.utils")

      require("lualine").setup({
        options = {
          section_separators = "",
          component_separators = "·",
          theme = (function()
            local kanagawa = require("lualine.themes.kanagawa")
            for _, mode in pairs(kanagawa) do
              for _, section in pairs(mode) do
                if type(section) == "table" then
                  section.bg = "NONE"
                end
              end
            end
            kanagawa.normal.a.fg = "#b35b79"
            return kanagawa
          end)(),
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
