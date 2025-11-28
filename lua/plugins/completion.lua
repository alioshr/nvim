local copilot_utils = require("scripts.copilot-utils")

return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  dependencies = {
    version = "v2.*",
    "rafamadriz/friendly-snippets",
    "giuxtaposition/blink-cmp-copilot",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  appearance = {
    nerd_font_variant = "mono",
    highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
  },
  opts = {
    keymap = {
      ["<cr>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = {
        "snippet_forward",
        function() -- sidekick next edit suggestion
          return require("sidekick").nes_jump_or_apply()
        end,
        -- function() -- if you are using Neovim's native inline completions
        --   return vim.lsp.inline_completion.get()
        -- end,
        "fallback",
      },
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
        },
        auto_show_delay_ms = 0,
        update_delay_ms = 50,
      },
      menu = {
        border = "rounded", -- Options: "none", "single", "double", "rounded", "solid", "shadow"
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        draw = {
          treesitter = { "lsp" },
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
    },
    fuzzy = { implementation = "prefer_rust" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
