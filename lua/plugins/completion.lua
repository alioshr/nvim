local copilot_utils = require("scripts.copilot-utils")
return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  dependencies = {
    "L3MON4D3/LuaSnip",
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
  -- Hack to remove duplicated items - https://github.com/Saghen/blink.cmp/issues/1222#event-18794466545
  config = function(_, opts)
    local original = require("blink.cmp.completion.list").show
    ---@diagnostic disable-next-line: duplicate-set-field
    require("blink.cmp.completion.list").show = function(ctx, items_by_source)
      local seen = {}
      local function filter(item)
        if seen[item.label] then
          return false
        end
        seen[item.label] = true
        return true
      end
      for id, source in pairs(items_by_source) do
        items_by_source[id] = source and vim.iter(source):filter(filter):totable()
      end
      return original(ctx, items_by_source)
    end
    require("blink.cmp").setup(opts)
  end,
  opts = {
    keymap = {
      ["<cr>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
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
  },
}
