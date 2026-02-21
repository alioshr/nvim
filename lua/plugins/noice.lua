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
          style = "none",
        },
      },
      popupmenu = {
        border = {
          style = "none",
        },
      },
      confirm = {
        border = {
          style = "none",
        },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    -- Override after noice sets highlights with default=true
    vim.api.nvim_set_hl(0, "NoiceConfirm", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NoiceFormatConfirm", { bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "NoiceFormatConfirmDefault", { bg = "NONE", bold = true, underline = true })
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
