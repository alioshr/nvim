-- Kanagawa Lotus (light)
return {
  plugin = { "rebelot/kanagawa.nvim" },

  apply = function()
    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      theme = "lotus",
    })
    vim.cmd.colorscheme("kanagawa")
  end,

  highlights = {
    float_border = "#8a8980",
    cursorline = "#e0d4e8",
    filename_fg = "#4e8ca2",
  },

  lualine_theme = function()
    local k = require("lualine.themes.kanagawa")
    for _, mode in pairs(k) do
      for _, section in pairs(mode) do
        if type(section) == "table" then
          section.bg = "NONE"
        end
      end
    end
    k.normal.a.fg = "#b35b79"
    return k
  end,
}
