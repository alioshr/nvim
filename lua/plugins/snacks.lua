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
      enabled = true,
      layout = {
        preset = "default",
        layout = {
          width = 0.99,
          height = 0.99,
        },
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      win = {
        input = {
          keys = {
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-w>"] = { "qflist", mode = { "n" } },
            ["<C-a>"] = { "qflist_all", mode = { "n" } },
            ["<ScrollWheelUp>"] = { "list_up", mode = { "i", "n" } },
            ["<ScrollWheelDown>"] = { "list_down", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["q"] = "close",
            ["<ScrollWheelUp>"] = "list_up",
            ["<ScrollWheelDown>"] = "list_down",
          },
        },
      },
      sources = {
        explorer = {
          layout = {
            preset = "sidebar",
            config = function(layout)
              if layout.layout and layout.layout[1] and layout.layout[1].win == "input" then
                layout.layout[1].title = "{title}"
              end
              return layout
            end,
          },
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
          args = { "--ignore-case", "--fixed-strings", "--sort=path", "--glob=!**/.git/**", "--glob=!**/node_modules/**" },
        },
        grep_word = {
          hidden = true,
          args = { "--ignore-case", "--fixed-strings", "--sort=path", "--glob=!**/.git/**", "--glob=!**/node_modules/**" },
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
    -- Explorer
    { "<leader>e", function() Snacks.explorer({ hidden = true }) end, desc = "File Explorer" },

    -- Files
    { "<leader>fF", function() Snacks.picker.recent() end, desc = "Find Files (Frecency)" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config Files" },

    -- Search
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Live Grep" },
    {
      "<leader>sg",
      function()
        vim.ui.input({ prompt = "Glob pattern (e.g. src/components/**): " }, function(glob)
          if not glob or glob == "" then
            return
          end
          Snacks.picker.grep({
            hidden = true,
            glob = glob,
            args = { "--ignore-case", "--sort=path", "--glob=!**/.git/**", "--glob=!**/node_modules/**" },
          })
        end)
      end,
      desc = "Live Grep with Path Filter",
    },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },

    -- Buffers
    {
      "<leader>,",
      function()
        Snacks.picker.buffers({
          layout = { preset = "select" },
          win = {
            input = {
              keys = {
                ["d"] = { "bufdelete", mode = "n" },
              },
            },
            list = {
              keys = {
                ["d"] = "bufdelete",
              },
            },
          },
        })
      end,
      desc = "Buffers",
    },

    -- Resume and History
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume Last Picker" },
    { "<leader>sp", function() require("scripts.picker-history")() end, desc = "Picker History" },

    -- Git
    { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log({ current_file = true }) end, desc = "Git Buffer Commits" },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "LSP Declarations" },
    { "<leader>gr", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "LSP Implementations" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "LSP Type Definitions" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },

    -- Vim
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Tags" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jump List" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    {
      "<leader>sQ",
      function()
        local qf_items = vim.fn.getqflist()
        local seen = {}
        local paths = {}
        for _, item in ipairs(qf_items) do
          local bufnr = item.bufnr
          if bufnr and bufnr > 0 then
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name ~= "" and not seen[name] then
              seen[name] = true
              table.insert(paths, name)
            end
          elseif item.filename and item.filename ~= "" and not seen[item.filename] then
            seen[item.filename] = true
            table.insert(paths, item.filename)
          end
        end
        if #paths == 0 then
          vim.notify("Quickfix list has no file entries", vim.log.levels.WARN)
          return
        end
        Snacks.picker.grep({
          title = string.format("Grep (Quickfix Files: %d)", #paths),
          dirs = paths,
        })
      end,
      desc = "Grep in Quickfix Files",
    },
  },
}
