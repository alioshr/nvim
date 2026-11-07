-- Lackluster (dark, mostly monochrome)
-- Palette: github.com/slugbyte/lackluster.nvim (lua/lackluster/color.lua)
-- Variants: "lackluster" (most monochrome), "lackluster-hack", "lackluster-mint"
return {
  plugin = { "slugbyte/lackluster.nvim" },

  apply = function()
    local lackluster = require("lackluster")
    local c = lackluster.color
    -- Accents that must stay far from the comment gray (CIELAB ΔE >= 18)
    local slate = "#54859e" -- types; default lack #708090 (ΔE 10.9 from comments)
    local taupe = "#937e63" -- calls; was #8a7f72 (ΔE 9.2 from comments)
    ---@diagnostic disable-next-line: missing-fields
    lackluster.setup({
      -- No near-white: dim the 3 brightest palette colors (contrast on #131313)
      tweak_color = {
        luster = "#b0c0be", -- function definitions, 9.8:1 (default #deeeed, 15.5:1)
        gray8 = "#b4b4b4", -- text and variables, 9.0:1 (default #cccccc); same as the Rex text
        gray9 = "#c0c0c0", -- brightest UI gray, 10.2:1 (default #dddddd)
        lack = slate, -- types, classes, enums, modules; 4.6:1
      },
      -- Subtle accents from lackluster's own palette; the rest stays gray
      tweak_syntax = {
        -- Comments: gray + italic (see tweak_highlight). Contrast 4.3:1 on #131313.
        comment = c.gray6,
        string = c.green, -- also YAML values
        string_escape = c.blue,
        type = slate,
        -- Keywords: muted mauve (not in the palette), so they do not look like
        -- comments. 4.9:1 on #131313
        keyword = "#8c7d9c",
        keyword_return = c.blue,
        keyword_exception = c.blue,
      },
      tweak_highlight = {
        ["Comment"] = { italic = true },
        ["@comment"] = { italic = true },
        ["@comment.documentation"] = { italic = true },
        ["@comment.todo"] = { fg = c.gray6, bold = true, italic = true },
        -- Function and method calls: warm taupe (not in the palette), 4.8:1 on #131313
        ["@function.call"] = { fg = taupe },
        ["@function.method.call"] = { fg = taupe },
        -- Brackets, delimiters and operators: one step dimmer than comments (gray5),
        -- the same as the JSX < /> delimiters. Default is gray6, the comment color.
        ["Operator"] = { fg = c.gray5 },
        ["Delimiter"] = { fg = c.gray5 },
        ["@operator"] = { fg = c.gray5 },
        ["@punctuation.bracket"] = { fg = c.gray5 },
        ["@punctuation.delimiter"] = { fg = c.gray5 },
        ["@punctuation.special"] = { fg = c.gray5 },
        ["@constructor"] = { fg = slate }, -- same as types (default: gray6)
        -- JSON/YAML/TOML keys: same as other properties (default: gray6, the comment color)
        ["@property.json"] = { fg = c.gray7 },
        ["@property.yaml"] = { fg = c.gray7 },
        ["@property.toml"] = { fg = c.gray7 },
        ["@number"] = { fg = c.yellow },
        ["@boolean"] = { fg = c.yellow },
        ["@constant.builtin"] = { fg = c.yellow },
        -- JSX/HTML tag names (components and builtins); delimiters stay gray
        ["@tag"] = { fg = c.blue },
        ["@tag.builtin"] = { fg = c.blue },
        -- JSX attribute names: pale blue, same family as tag names (default gray4, 1.9:1)
        ["@tag.attribute"] = { fg = "#959fb3" },
        -- Parameters (also the LSP group, which links here): default #8e8e8e is
        -- too close to the comment gray
        ["@variable.parameter"] = { fg = c.gray7 },
        -- The LSP tags every function name as "function", also calls. Keep the
        -- definition color for declarations only; calls get the call color.
        ["@lsp.type.function"] = { overwrite = true, link = "@function.call" },
        ["@lsp.type.method"] = { overwrite = true, link = "@function.method.call" },
        ["@lsp.typemod.function.declaration"] = { overwrite = true, link = "@function" },
        ["@lsp.typemod.method.declaration"] = { overwrite = true, link = "@function.method" },
        -- Selection: a dim block that keeps the syntax colors
        -- (default: light gray block with black text)
        ["Visual"] = { overwrite = true, bg = c.gray4 },
        -- Groups that lackluster does not set; their defaults are white blocks
        ["WinBar"] = { overwrite = true, fg = c.gray6, bg = "NONE", bold = true },
        ["WinBarNC"] = { overwrite = true, fg = c.gray5, bg = "NONE" },
        ["MiniJump2dSpotAhead"] = { overwrite = true, fg = c.gray6, bg = c.gray3 },
        -- nvim-notify blends its fade animation into this bg and warns at startup
        -- when it has none (transparent theme). #131313 is the Rex background.
        ["NotifyBackground"] = { overwrite = true, bg = "#131313" },
      },
      tweak_background = {
        normal = "none",
        telescope = "none",
        menu = lackluster.color.gray3,
        popup = "default",
      },
    })
    vim.cmd.colorscheme("lackluster")

    -- lackluster has no indent-blankline groups. ibl then copies LineNr,
    -- which plugins/theme.lua clears, and ibl fails at startup.
    vim.api.nvim_set_hl(0, "IblIndent", { fg = lackluster.color.gray3 })
    vim.api.nvim_set_hl(0, "IblWhitespace", { fg = lackluster.color.gray3 })
    vim.api.nvim_set_hl(0, "IblScope", { fg = lackluster.color.gray5 })
  end,

  highlights = {
    float_border = "#555555", -- gray5
    cursorline = "#2a2a2a", -- gray3 (gray2 is too close to the terminal background)
    filename_fg = "#b0c0be", -- luster (dimmed in tweak_color)
  },

  lualine_theme = function()
    local bg = "NONE"
    local fg = "#aaaaaa" -- gray7
    local muted = "#444444" -- gray4
    local mk = function(accent)
      return {
        a = { fg = accent, bg = bg, gui = "bold" },
        b = { fg = fg, bg = bg },
        c = { fg = fg, bg = bg },
      }
    end
    return {
      normal = mk("#b0c0be"), -- luster (dimmed in tweak_color)
      insert = mk("#789978"), -- green
      visual = mk("#7788aa"), -- blue
      replace = mk("#ffaa88"), -- orange
      command = mk("#abab77"), -- yellow
      inactive = {
        a = { fg = muted, bg = bg },
        b = { fg = muted, bg = bg },
        c = { fg = muted, bg = bg },
      },
    }
  end,
}
