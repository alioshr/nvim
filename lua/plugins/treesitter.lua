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
    local ts = require("nvim-treesitter")
    local parsers = require("nvim-treesitter.parsers")

    -- Install core parsers at startup
    ts.install({
      "bash",
      "comment",
      "css",
      "diff",
      "fish",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "norg",
      "python",
      "query",
      "regex",
      "scss",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "typst",
      "vim",
      "vimdoc",
      "vue",
      "xml",
    })

    local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

    local ignore_filetypes = {
      "checkhealth",
      "lazy",
      "mason",
      "snacks_dashboard",
      "snacks_notif",
      "snacks_win",
    }

    -- Auto-install parsers and enable highlighting on FileType
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      desc = "Enable treesitter highlighting and indentation",
      callback = function(event)
        if vim.tbl_contains(ignore_filetypes, event.match) then
          return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local supported = false

        if not lang then
          return
        end

        if parsers.get_parser_configs then
          local parser_configs = parsers.get_parser_configs()
          supported = parser_configs[lang] ~= nil
        elseif parsers.available_parsers then
          for _, parser in ipairs(parsers.available_parsers()) do
            if parser == lang then
              supported = true
              break
            end
          end
        else
          supported = true
        end

        if not supported then
          return
        end
        local buf = event.buf

        -- Start highlighting immediately (works if parser exists)
        pcall(vim.treesitter.start, buf, lang)

        -- Enable treesitter indentation
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- Install missing parsers (async, no-op if already installed)
        if parsers.has_parser then
          if not parsers.has_parser(lang) then
            ts.install({ lang })
          end
        else
          ts.install({ lang })
        end
      end,
    })
  end,
}
