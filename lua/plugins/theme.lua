return {
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
        transparent = true, -- allow terminal transparency to show through
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        theme = "lotus",
      })

      -- setup must be called before loading
      vim.cmd.colorscheme("kanagawa")

      -- Make gutter/sign column transparent
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#8a8980", bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

      -- Make git sign highlights transparent
      vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsChangedelete", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsTopdelete", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "GitSignsUntracked", { bg = "NONE" })

      -- Make treesitter-context transparent
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { bg = "NONE", underline = true })

      -- Noice cmdline underline separator
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "NONE", underdouble = true, sp = "#8a8980" })

      -- Never show tabline — override any plugin that tries to restore it
      vim.opt.showtabline = 0
      vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "showtabline",
        callback = function()
          if vim.o.showtabline ~= 0 then
            vim.o.showtabline = 0
          end
        end,
      })

      -- Make Telescope transparent
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE" })
    end,
  },
}
