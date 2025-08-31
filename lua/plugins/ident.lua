return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      -- highlight = highlightDimLines,
      char = "┊",
      tab_char = "┊",
    },
    scope = {
      -- highlight = highlightLines,
      char = "│",
    },
  },
}
