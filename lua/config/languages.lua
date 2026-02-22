local M = {}

M.registry = {
  lua = {
    filetypes = { "lua" },
    lsp = { "lua_ls" },
    treesitter = {
      parser = "lua",
      folds = true,
    },
  },
  javascript = {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
    lsp = { "ts_ls", "eslint" },
    treesitter = {
      parser = "javascript",
      folds = true,
    },
  },
  typescript = {
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    lsp = { "ts_ls", "eslint" },
    treesitter = {
      parser = "typescript",
      parser_by_filetype = {
        typescriptreact = "tsx",
        ["typescript.tsx"] = "tsx",
      },
      folds = true,
    },
  },
  json = {
    filetypes = { "json", "jsonc" },
    lsp = { "jsonls" },
    treesitter = {
      parser = "json",
      folds = true,
    },
  },
  toml = {
    filetypes = { "toml" },
    lsp = { "taplo" },
    treesitter = {
      parser = "toml",
      folds = true,
    },
  },
  yaml = {
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
    lsp = { "yamlls" },
    treesitter = {
      parser = "yaml",
      folds = true,
    },
  },
  vue = {
    filetypes = { "vue" },
    lsp = { "eslint" },
    treesitter = {
      parser = "vue",
      folds = true,
    },
  },
  svelte = {
    filetypes = { "svelte" },
    lsp = { "eslint" },
    treesitter = {
      parser = "svelte",
      folds = true,
    },
  },
  astro = {
    filetypes = { "astro" },
    lsp = { "eslint" },
    treesitter = {
      parser = "astro",
      folds = true,
    },
  },
  angular = {
    filetypes = { "htmlangular" },
    lsp = { "eslint" },
    treesitter = {
      parser = "angular",
      folds = true,
    },
  },
}

M.server_to_mason = {
  lua_ls = "lua-language-server",
  ts_ls = "typescript-language-server",
  eslint = "eslint-lsp",
  taplo = "taplo",
  yamlls = "yaml-language-server",
  jsonls = "json-lsp",
}

M.treesitter_extra_parsers = {
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
  "latex",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "scss",
  "typst",
  "vim",
  "vimdoc",
  "xml",
}

M.treesitter_extra_fold_filetypes = {
  bash = true,
  css = true,
  fish = true,
  html = true,
  python = true,
  scss = true,
  typst = true,
  vim = true,
  xml = true,
}

local function uniq(list)
  local seen = {}
  local out = {}
  for _, value in ipairs(list) do
    if value and value ~= "" and not seen[value] then
      seen[value] = true
      out[#out + 1] = value
    end
  end
  table.sort(out)
  return out
end

function M.lsp_filetypes_by_server()
  local map = {}

  for _, language in pairs(M.registry) do
    for _, server in ipairs(language.lsp or {}) do
      map[server] = map[server] or {}
      for _, ft in ipairs(language.filetypes or {}) do
        map[server][#map[server] + 1] = ft
      end
    end
  end

  for server, filetypes in pairs(map) do
    map[server] = uniq(filetypes)
  end

  return map
end

function M.lsp_servers()
  return uniq(vim.tbl_keys(M.lsp_filetypes_by_server()))
end

function M.mason_lsp_packages()
  local packages = {}
  for _, server in ipairs(M.lsp_servers()) do
    local package = M.server_to_mason[server]
    if package then
      packages[#packages + 1] = package
    end
  end
  return uniq(packages)
end

function M.treesitter_parser_by_filetype()
  local map = {}

  for _, language in pairs(M.registry) do
    local ts = language.treesitter or {}
    local default_parser = ts.parser
    local overrides = ts.parser_by_filetype or {}

    for _, ft in ipairs(language.filetypes or {}) do
      local parser = overrides[ft] or default_parser
      if parser then
        map[ft] = parser
      end
    end
  end

  return map
end

function M.treesitter_parsers()
  local parsers = {}
  local parser_by_ft = M.treesitter_parser_by_filetype()

  for _, parser in pairs(parser_by_ft) do
    parsers[#parsers + 1] = parser
  end

  for _, parser in ipairs(M.treesitter_extra_parsers) do
    parsers[#parsers + 1] = parser
  end

  return uniq(parsers)
end

function M.treesitter_fold_filetypes()
  local map = {}

  for ft, enabled in pairs(M.treesitter_extra_fold_filetypes) do
    if enabled then
      map[ft] = true
    end
  end

  for _, language in pairs(M.registry) do
    if language.treesitter and language.treesitter.folds then
      for _, ft in ipairs(language.filetypes or {}) do
        map[ft] = true
      end
    end
  end

  return map
end

return M
