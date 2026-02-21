return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local utils = require("scripts.utils")

      require("lualine").setup({
        options = {
          section_separators = "",
          component_separators = "·",
          theme = (function()
            local kanagawa = require("lualine.themes.kanagawa")
            for _, mode in pairs(kanagawa) do
              for _, section in pairs(mode) do
                if type(section) == "table" then
                  section.bg = "NONE"
                end
              end
            end
            kanagawa.normal.a.fg = "#b35b79"
            return kanagawa
          end)(),
        },
        sections = {
          lualine_a = {
            {
              utils.get_cwd_basename,
              icon = "",
              color = { gui = "bold" },
            },
          },
          lualine_c = {
            {
              function()
                local path = vim.fn.expand("%:~:.")
                if path == "" then return "[No Name]" end
                local filename = vim.fn.fnamemodify(path, ":t")
                local modified = vim.bo.modified and " ●" or ""
                local dir = vim.fn.fnamemodify(path, ":h")
                if dir == "." then return filename .. modified end

                -- Reserve space: ~50% of columns for other sections
                local budget = math.floor(vim.o.columns * 0.5)
                local file_part = filename .. modified .. "  "
                local path_budget = budget - #file_part
                if path_budget <= 4 then return filename .. modified end

                local display_dir = dir
                if #dir > path_budget then
                  local parts = vim.split(dir, "/")
                  display_dir = ""
                  for i = #parts, 1, -1 do
                    local candidate = parts[i] .. (display_dir == "" and "" or ("/" .. display_dir))
                    if #candidate + 2 > path_budget then break end
                    display_dir = candidate
                  end
                  display_dir = "…/" .. display_dir
                end

                return filename .. modified .. "  %#lualine_c_inactive#" .. display_dir
              end,
              color = { fg = "#545464", gui = "bold", bg = "NONE" },
            },
          },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_x = { "filetype" },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_workspace_diagnostic" },
            },
          },
          lualine_z = {},
        },
      })
    end,
  },
}
