return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot" },

  version = "1.*",
  -- here you might want to specify the method or usage of 'vim'
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
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
        appearance = {
          module = "blink-cmp-copilot",
        },
      },
    },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" },
}
