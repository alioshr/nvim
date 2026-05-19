-- Catppuccin Frappé
-- Palette: catppuccin.com/palette
return {
  plugin = { "catppuccin/nvim", name = "catppuccin" },

  apply = function()
    require("catppuccin").setup({
      flavour = "frappe",
      transparent_background = true,
      term_colors = true,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
        functions = {},
        conditionals = { "italic" },
      },
      integrations = {
        gitsigns = true,
        treesitter = true,
        treesitter_context = true,
        telescope = { enabled = true },
        snacks = { enabled = true },
        noice = true,
        mason = true,
        notify = true,
        which_key = true,
        native_lsp = { enabled = true },
        mini = { enabled = true },
        indent_blankline = { enabled = true, colored_indent_levels = false },
        dap = true,
        dap_ui = true,
      },
    })
    vim.cmd.colorscheme("catppuccin-frappe")
  end,

  highlights = {
    float_border = "#838ba7", -- Overlay1
    cursorline = "#51576d", -- Surface1
    filename_fg = "#85c1dc", -- Sapphire
  },

  lualine_theme = function()
    local bg = "NONE"
    local fg = "#c6d0f5" -- Text
    local muted = "#838ba7" -- Overlay1
    local mk = function(accent)
      return {
        a = { fg = accent, bg = bg, gui = "bold" },
        b = { fg = fg, bg = bg },
        c = { fg = fg, bg = bg },
      }
    end
    return {
      normal = mk("#f2d5cf"), -- Rosewater
      insert = mk("#a6d189"), -- Green
      visual = mk("#ca9ee6"), -- Mauve
      replace = mk("#e78284"), -- Red
      command = mk("#e5c890"), -- Yellow
      inactive = {
        a = { fg = muted, bg = bg },
        b = { fg = muted, bg = bg },
        c = { fg = muted, bg = bg },
      },
    }
  end,
}
