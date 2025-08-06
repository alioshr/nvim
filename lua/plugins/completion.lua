local copilot_utils = require("scripts.copilot-utils")
return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot" },
  build = "cargo build --release",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  appearance = {
    nerd_font_variant = "mono",
  },
  opts = {
    keymap = {
      ["<cr>"] = { "accept", "fallback" },
      ["<C><leader>"] = { "show" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
      trigger = {
        show_on_backspace_in_keyword = true,
        show_on_trigger_character = true,
        show_on_keyword = true,
        show_on_insert = true,
        show_on_insert_on_trigger_character = true,
        prefetch_on_insert = true,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        update_delay_ms = 50,
      },
      menu = {
        auto_show = true,
        draw = {
          treesitter = { "lsp" },
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_insert = true,
        show_on_keyword = true,
      },
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
        },
      },
    },
    fuzzy = { implementation = "lua" },
  },
}
