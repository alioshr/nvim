---@module "lazy"
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local languages = require("config.languages")
    local ts = require("nvim-treesitter")
    local parsers = require("nvim-treesitter.parsers")
    local core_parsers = languages.treesitter_parsers()
    local fold_filetypes = languages.treesitter_fold_filetypes()
    local parser_by_filetype = languages.treesitter_parser_by_filetype()

    local function has_installed_parser(lang)
      return pcall(vim.treesitter.language.inspect, lang)
    end

    -- Install core parsers at startup
    ts.install(core_parsers)

    local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

    -- Enable treesitter features on supported, parser-backed filetypes.
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      desc = "Enable treesitter highlighting, indentation, and folds",
      callback = function(event)
        local buf = event.buf
        local ft = event.match

        if ft == "" or not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        if vim.bo[buf].buftype ~= "" then
          return
        end

        local lang = parser_by_filetype[ft] or vim.treesitter.language.get_lang(ft) or ft

        if type(lang) ~= "string" or lang == "" then
          return
        end

        if not parsers[lang] then
          return
        end

        if not has_installed_parser(lang) then
          return
        end

        pcall(vim.treesitter.start, buf, lang)

        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        if fold_filetypes[ft] and not vim.wo[0].diff then
          vim.wo[0].foldmethod = "expr"
          vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
