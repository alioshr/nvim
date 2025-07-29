return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "accept", "fallback" },
      ["<C><leader>"] = { "show" },
      ["<Tab>"] = {
        function(cmp)
          if vim.b[vim.api.nvim_get_current_buf()].nes_state then
            cmp.hide()
            return (
              require("copilot-lsp.nes").apply_pending_nes()
              and require("copilot-lsp.nes").walk_cursor_end_edit()
            )
          end
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
    },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = { documentation = { auto_show = true } },

  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot" },
    per_filetype = {
    codecompanion = { "codecompanion" },
  }
 },

  fuzzy = { implementation = "prefer_rust_with_warning" },
}
