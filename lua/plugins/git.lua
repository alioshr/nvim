return {
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git: Open panel" },
      { "<leader>hd", "<cmd>DiffviewOpen<cr>", desc = "Git: Open 3 way conflict resolution" },
    },
    config = function()
      -- Disable swap files for Neogit buffers to prevent E325 errors
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "Neogit*",
        callback = function()
          vim.opt_local.swapfile = false
        end,
      })

      require("neogit").setup({
        disable_commit_confirmation = true,
        disable_insert_on_commit = true,
        remember_settings = true,
        mappings = {
          status = {
            ["K"] = false,
            ["<leader>K"] = "Untrack",
          },
        },
        integrations = {
          diffview = true,
          codediff = true,
          telescope = true,
        },
        diff_viewer = "codediff",
        builders = {
          NeogitCommitPopup = function(popup)
            local override = require("scripts.override-neogit-flag")
            override.enableAndPersist(popup, { "no-verify" })
          end,
          NeogitPushPopup = function(popup)
            local override = require("scripts.override-neogit-flag")
            override.enableAndPersist(popup, { "force" })
          end,
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {
      keymaps = {
        explorer = {
          hover = "<leader>K",
        },
      },
    },
    config = function(_, opts)
      require("codediff").setup(opts)

      -- Auto-preview diff on cursor move in explorer
      local debounce_timer = nil
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "codediff-explorer",
        callback = function(ev)
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = ev.buf,
            callback = function()
              if debounce_timer then
                debounce_timer:stop()
              end
              debounce_timer = vim.defer_fn(function()
                if not vim.api.nvim_buf_is_valid(ev.buf) then
                  return
                end
                local lifecycle = require("codediff.ui.lifecycle")
                local tabpage = vim.api.nvim_get_current_tabpage()
                local explorer = lifecycle.get_explorer(tabpage)
                if not explorer or not explorer.tree then
                  return
                end
                local node = explorer.tree:get_node()
                if node and node.data and node.data.type ~= "group" and node.data.type ~= "directory" then
                  explorer.on_file_select(node.data)
                end
              end, 150)
            end,
          })
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    keys = {
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Git: Stage Hunk" },
      { "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Git: Stage Buffer" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Git: Preview Hunk" },
      { "<leader>hi", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Git: Preview Hunk Inline" },
      { "<leader>hv", "<cmd>Gitsigns select_hunk<cr>", desc = "Git: Select Hunk" },
      { "<leader>hb", "<cmd> Gitsigns blame<cr>", desc = "Git: Show file blame" },
    },
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.toggle_current_line_blame(true)
    end,
  },
}
