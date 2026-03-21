return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = "mono",
      highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
    },
    keymap = {
      ["<cr>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = {
        function() -- sidekick next edit suggestion
          return require("sidekick").nes_jump_or_apply()
        end,
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
      default = { "lsp", "path", "buffer" },
    },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    local function set_blink_highlights()
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
    end

    set_blink_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("BlinkCmpHighlights", { clear = true }),
      callback = set_blink_highlights,
    })
  end,
}
