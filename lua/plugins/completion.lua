local copilot_utils = require("scripts.copilot-utils")

return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot" },

  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = { documentation = { auto_show = true } },
  opts = {
    keymap = {
      ["<Tab>"] = { "accept", "fallback" },
      ["<C><leader>"] = { "show" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          transform_items = copilot_utils.transform_copilot_items,
          appearance = {
            module = "blink-cmp-copilot",
          },
        },
      },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
