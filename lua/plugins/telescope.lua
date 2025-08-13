return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    config = function()
      local function filenameFirst(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        end
        return string.format("%s\t\t%s", tail, parent)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
          end)
        end,
      })

      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local action_state = require("telescope.actions.state")

      vim.keymap.set("n", "<leader>,", function()
        builtin.buffers({
          initial_mode = "normal",
          attach_mappings = function(prompt_bufnr, map)
            local delete_buf = function()
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              current_picker:delete_selection(function(selection)
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
              end)
            end

            map("n", "d", delete_buf)

            return true
          end,
        }, {
          sort_lastused = true,
          sort_mru = true,
          theme = "dropdown",
        })
      end)

      telescope.setup({
        defaults = {
          path_display = filenameFirst,
          cache_picker = {
            num_pickers = 100,
            limit_entries = 1000,
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.6,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.99,
            height = 0.99,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending",
          winblend = 0,
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.cycle_previewers_next,
              ["<C-h>"] = actions.cycle_previewers_prev,
              ["<ScrollWheelUp>"] = function(prompt_bufnr)
                actions.move_selection_previous(prompt_bufnr)
              end,
              ["<ScrollWheelDown>"] = function(prompt_bufnr)
                actions.move_selection_next(prompt_bufnr)
              end,
              ["<ScrollWheelLeft>"] = actions.results_scrolling_left,
              ["<ScrollWheelRight>"] = actions.results_scrolling_right,
            },
            n = {
              ["q"] = actions.close,
              ["<ScrollWheelUp>"] = function(prompt_bufnr)
                actions.move_selection_previous(prompt_bufnr)
              end,
              ["<ScrollWheelDown>"] = function(prompt_bufnr)
                actions.move_selection_next(prompt_bufnr)
              end,
              ["<ScrollWheelLeft>"] = actions.results_scrolling_left,
              ["<ScrollWheelRight>"] = actions.results_scrolling_right,
            },
          },
        },
        pickers = {
          live_grep = {
            additional_args = function()
              return { "--ignore-case", "--fixed-strings" }
            end,
          },
          grep_string = {
            additional_args = function()
              return { "--ignore-case", "--fixed-strings" }
            end,
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            -- Don't add --fixed-strings here to allow glob patterns
            additional_args = function()
              return { "--ignore-case" }
            end,
          },
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
    end,
    keys = {
      -- Files
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Git Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config Files",
      },

      -- Search
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (Fixed Strings)" },
      {
        "<leader>sg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            default_text = '"t" --glob=**/*',
          })
        end,
        desc = "Live Grep with Path Filter",
      },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep Word" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Lines" },

      -- Resume and History
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume Last Picker" },
      { "<leader>sp", "<cmd>Telescope pickers<cr>", desc = "Picker History" },

      -- Git
      { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
      { "<leader>gl", "<cmd>Telescope git_commits<cr>", desc = "Git Log" },
      { "<leader>gL", "<cmd>Telescope git_bcommits<cr>", desc = "Git Buffer Commits" },

      -- LSP
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
      { "gD", "<cmd>Telescope lsp_declarations<cr>", desc = "LSP Declarations" },
      { "<leader>gr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
      { "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },

      -- Vim
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jump List" },
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search History" },
      { "<leader>uC", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
    },
  },
  {
    "nvim-telescope/telescope-project.nvim",
    config = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fp",
        ":lua require'telescope'.extensions.project.project{}<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
}
