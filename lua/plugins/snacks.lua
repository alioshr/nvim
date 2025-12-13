return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    picker = {
      include = { "node_modules", ".*" },
      enabled = false,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer({ hidden = true })
      end,
      desc = "File Explorer",
    },
  },
}
