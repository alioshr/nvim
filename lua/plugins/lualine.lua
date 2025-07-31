return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function get_dir_name()
        local cwd = vim.fn.getcwd()
        return vim.fn.fnamemodify(cwd, ":t")
      end

      require("lualine").setup({
        options = {
          theme = "catppuccin",
        },
        sections = {
          lualine_a = {
            {
              get_dir_name,
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
              "diawgnostics",
              sources = { "nvim_workspace_diagnostic" },
            },
          },
          lualine_z = {},
        },
      })
    end,
  },
}
