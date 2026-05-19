-- Active theme — swap this line to change colors across nvim.
-- Available themes live in lua/themes/<name>.lua and each owns:
--   plugin       lazy.nvim spec for the colorscheme plugin
--   apply        function that calls setup() + colorscheme()
--   highlights   { float_border, cursorline, filename_fg }
--   lualine_theme function returning a lualine theme table
return require("themes.catppuccin-frappe")
-- return require("themes.kanagawa-lotus")
