return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
      },
      sections = {
        {
          section = "terminal",
          cmd = [[echo 'I am altering the project'\''s scope. Pray I don'\''t alter it any further.
  		-- Product Owner' | cowsay -f vader]],
          hl = "header",
          padding = 1,
          height = 15,
          indent = 8,
        },
        { icon = "", title = "Don't read this crap", padding = 1 },
        { section = "keys", padding = 1, indent = 2 },
        { icon = " ", title = "Projects", padding = 1 },
        { section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
  },
}
