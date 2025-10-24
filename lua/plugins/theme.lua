return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
    },
    config = function()
      -- vim.cmd.colorscheme("tokyonight")
      -- Override unused variable colors
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#8a92b3" })
      vim.api.nvim_set_hl(0, "@variable.unused", { fg = "#8a92b3" })
      vim.api.nvim_set_hl(0, "@parameter.unused", { fg = "#8a92b3" })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          local theme = colors.theme
          return {
            -- Cursor colors for better visibility (dark cursor on light background)
            Cursor = { fg = "#DCD7BA", bg = "#2D4F67" }, -- Dark blue-grey
            lCursor = { fg = "#DCD7BA", bg = "#2D4F67" },
            CursorIM = { fg = "#DCD7BA", bg = "#2D4F67" },
            TermCursor = { fg = "#DCD7BA", bg = "#2D4F67" },
            -- Alternative dark colors:
            -- Cursor = { fg = "#DCD7BA", bg = "#1F1F28" }, -- Very dark grey
            -- Cursor = { fg = "#DCD7BA", bg = "#43242B" }, -- Dark red
          }
        end,
        theme = "dragon", -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = "lotus", -- try "dragon" !
          light = "lotus",
        },
      })

      -- setup must be called before loading
      vim.cmd.colorscheme("kanagawa")

      -- Force cursor colors after colorscheme loads
      vim.api.nvim_set_hl(0, "Cursor", { fg = "#DCD7BA", bg = "#bd9dd4" }) -- RGB(239, 223, 245)
      vim.api.nvim_set_hl(0, "lCursor", { fg = "#DCD7BA", bg = "#bd9dd4" })
      vim.api.nvim_set_hl(0, "CursorIM", { fg = "#DCD7BA", bg = "#bd9dd4" })
      vim.api.nvim_set_hl(0, "TermCursor", { fg = "#DCD7BA", bg = "#bd9dd4" })

      -- Set terminal cursor color (for terminal emulators that support it)
      -- n-v-c: normal/visual/command mode = block cursor
      -- i-ci-ve: insert mode = vertical bar at 50% width (thicker)
      -- r-cr: replace mode = horizontal bar at 20% height
      vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver50-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"
    end,
  },
}
