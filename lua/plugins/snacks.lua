return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    picker = {
      include = { "node_modules", "pdfs", ".*" },
      enabled = false,
      sources = {
        explorer = {
          layout = {
            preset = "sidebar",
            config = function(layout)
              -- Keep the title label, but remove status flags (like `h`) from the header.
              if layout.layout and layout.layout[1] and layout.layout[1].win == "input" then
                layout.layout[1].title = "{title}"
              end
              return layout
            end,
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    local function set_snacks_title_highlights()
      local ok, float_title = pcall(vim.api.nvim_get_hl, 0, { name = "FloatTitle", link = false })
      if ok and not vim.tbl_isempty(float_title) then
        float_title.bg = nil
        float_title.ctermbg = nil
        vim.api.nvim_set_hl(0, "FloatTitle", float_title)
      end

      -- Make Snacks title groups follow transparent FloatTitle styling.
      vim.api.nvim_set_hl(0, "SnacksTitle", { link = "FloatTitle" })
      vim.api.nvim_set_hl(0, "SnacksPickerTitle", { link = "FloatTitle" })
      vim.api.nvim_set_hl(0, "SnacksPickerBoxTitle", { link = "SnacksPickerTitle" })
    end

    set_snacks_title_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("SnacksTransparentTitles", { clear = true }),
      callback = set_snacks_title_highlights,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer({ hidden = true })
      end,
      desc = "File Explorer",
    },
  },
}
