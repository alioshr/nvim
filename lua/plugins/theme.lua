local theme = require("themes")

return {
  vim.tbl_extend("force", theme.plugin, {
    lazy = false,
    priority = 1000,
    config = function()
      theme.apply()

      -- Make gutter/sign column transparent
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = theme.highlights.float_border, bg = "NONE" })
      local function clear_sign_bg(group, fallback_link)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok and not vim.tbl_isempty(hl) then
          hl.bg = nil
          hl.ctermbg = nil
          vim.api.nvim_set_hl(0, group, hl)
        else
          vim.api.nvim_set_hl(0, group, { link = fallback_link })
        end
      end
      clear_sign_bg("DiagnosticSignError", "DiagnosticError")
      clear_sign_bg("DiagnosticSignWarn", "DiagnosticWarn")
      clear_sign_bg("DiagnosticSignInfo", "DiagnosticInfo")
      clear_sign_bg("DiagnosticSignHint", "DiagnosticHint")
      clear_sign_bg("DiagnosticSignOk", "DiagnosticOk")
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

      -- Noice cmdline popup body
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "NONE" })

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

      -- Selection highlight
      vim.api.nvim_set_hl(0, "CursorLine", { bg = theme.highlights.cursorline })
      vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = theme.highlights.cursorline })

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
  }),
}
