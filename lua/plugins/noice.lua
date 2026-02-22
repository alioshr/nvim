return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {
    lsp = {
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
    },
    cmdline = {
      opts = {
        border = {
          text = false,
        },
      },
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim", title = "" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", title = "" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", title = "" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash", title = "" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua", title = "" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "", title = "" },
        calculator = { pattern = "^=", icon = "", lang = "vimnormal", title = "" },
        input = { view = "cmdline_popup", icon = "󰥻 ", title = "" },
      },
    },
    views = {
      cmdline_popup = {
        border = {
          style = "rounded",
          padding = { 0, 0 },
        },
      },
      cmdline_input = {
        border = {
          style = "rounded",
          padding = { 0, 0 },
        },
      },
      popupmenu = {
        border = {
          style = "rounded",
          padding = { 0, 0 },
        },
      },
      confirm = {
        border = {
          style = "rounded",
          padding = { 0, 0 },
          text = false,
        },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    local function set_noice_highlights()
      local function clear_bg(group)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = true })
        if ok and not vim.tbl_isempty(hl) then
          hl.bg = nil
          hl.ctermbg = nil
          hl.link = nil
          hl.default = nil
          vim.api.nvim_set_hl(0, group, hl)
        else
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end
      end

      -- Force Noice border groups to use FloatBorder, which already has transparent bg.
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "NoicePopupBorder", { link = "FloatBorder" })

      -- Keep popup body transparent.
      vim.api.nvim_set_hl(0, "NoiceConfirm", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoicePopupmenu", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NoicePopup", { bg = "NONE" })

      -- Existing confirm action formatting.
      vim.api.nvim_set_hl(0, "NoiceFormatConfirm", { bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "NoiceFormatConfirmDefault", { bg = "NONE", bold = true, underline = true })

      -- Keep the progress fill, but remove the static "todo" track background.
      clear_bg("NoiceFormatProgressTodo")
    end

    -- Noice initializes on a deferred callback; re-apply once it has set defaults.
    vim.schedule(set_noice_highlights)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NoiceTransparentHighlights", { clear = true }),
      callback = set_noice_highlights,
    })
  end,
  dependencies = {
    {
      "MunifTanjim/nui.nvim",
    },
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 0,
        stages = "fade",
        render = "minimal",
      },
    },
  },
}
