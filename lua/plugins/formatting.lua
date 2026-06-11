return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      local prettier_configs = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.mjs",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        ".prettierrc.toml",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.mjs",
      }
      local biome_configs = { "biome.json", "biome.jsonc" }
      local oxfmt_configs = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts", "oxfmt.config.js" }

      local uv = vim.uv or vim.loop

      local function exists(path)
        return uv.fs_stat(path) ~= nil
      end

      --- Nearest ancestor dir that installs oxfmt locally. This is the generic
      --- "this project uses oxfmt" signal -- only the project's own dependency
      --- counts, so a sibling/parent package can't pull us in.
      ---@param filepath string
      ---@return string|nil project root
      local function oxfmt_root(filepath)
        for dir in vim.fs.parents(filepath) do
          if exists(dir .. "/node_modules/.bin/oxfmt") then
            return dir
          end
        end
        return nil
      end

      --- Resolve the config path the project itself passes to oxfmt (some repos
      --- keep it in node_modules and reference it via the package.json script's
      --- -c/--config flag). Parsed only from inside the oxfmt command string and
      --- resolved relative to root, so other scripts/packages can't contaminate.
      ---@param root string
      ---@return string|nil
      local function oxfmt_config(root)
        local f = io.open(root .. "/package.json", "r")
        if not f then
          return nil
        end
        local pkg = f:read("*a")
        f:close()
        -- Flag must sit in the same JSON string as an `oxfmt` invocation, so the
        -- `"oxfmt": "^x"` dependency entry (no flag) is skipped automatically.
        local path = pkg:match("oxfmt[^\"]*%-%-config[=%s]+([^%s\"]+)")
          or pkg:match("oxfmt[^\"]*%-c[=%s]+([^%s\"]+)")
        if not path then
          return nil
        end
        if not path:match("^/") then
          path = root .. "/" .. path
        end
        return exists(path) and path or nil
      end

      --- Returns { "oxfmt" }, { "biome" }, { "prettier" }, or {} based on project config
      ---@param bufnr number
      ---@return string[]
      local function web_formatter(bufnr)
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if oxfmt_root(filepath) or vim.fs.find(oxfmt_configs, { path = filepath, upward = true })[1] then
          return { "oxfmt" }
        end
        if vim.fs.find(biome_configs, { path = filepath, upward = true })[1] then
          return { "biome" }
        end
        if vim.fs.find(prettier_configs, { path = filepath, upward = true })[1] then
          return { "prettier" }
        end
        return {}
      end

      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = web_formatter,
          javascriptreact = web_formatter,
          typescript = web_formatter,
          typescriptreact = web_formatter,
          json = web_formatter,
          jsonc = web_formatter,
          graphql = web_formatter,
          yaml = web_formatter,
          yml = web_formatter,
        },
        formatters = {
          stylua = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/stylua"),
            prepend_args = { "--config-path", vim.fn.expand("~/.config/nvim/.stylua.toml") },
          },
          prettier = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/prettier"),
            -- Use project config if available, fallback to global config
            prepend_args = function(_, ctx)
              local project_config =
                vim.fs.find(prettier_configs, { path = ctx.filename, upward = true })[1]
              if not project_config then
                return { "--config", vim.fn.expand("~/.config/nvim/.prettierrc") }
              end
              return {}
            end,
          },
          biome = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/biome"),
          },
          oxfmt = {
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/oxfmt"),
            -- Pass the config the project itself references so editor output
            -- matches its format script; otherwise fall back to oxfmt defaults.
            prepend_args = function(_, ctx)
              local root = oxfmt_root(ctx.filename)
              local cfg = root and oxfmt_config(root)
              if cfg then
                return { "-c", cfg }
              end
              return {}
            end,
          },
        },
        default_format_opts = {
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
