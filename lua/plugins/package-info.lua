return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    highlights = {
      up_to_date = { fg = "#3C4048" }, -- Text color for up to date dependency virtual text
      outdated = { fg = "#d19a66" }, -- Text color for outdated dependency virtual text
      invalid = { fg = "#ee4b2b" }, -- Text color for invalid dependency virtual text
    },
    icons = {
      enable = true, -- Whether to display icons
      style = {
        up_to_date = "󰩐 |", -- Icon for up to date dependencies
        outdated = "󰀨 |", -- Icon for outdated dependencies
        invalid = "󰚑 |", -- Icon for invalid dependencies
      },
    },
    notifications = true, -- Whether to display notifications when running commands
    autostart = false, -- Whether to autostart when `package.json` is opened
    hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
    hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
    -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
    -- The plugin will try to auto-detect the package manager based on
    -- `yarn.lock` or `package-lock.json`. If none are found it will use the
    -- provided one, if nothing is provided it will use `yarn`
    -- package_manager = "yarn",
  },
  config = function(_, opts)
    require("package-info").setup(opts)

    -- manually register them
    vim.cmd([[highlight PackageInfoUpToDateVersion guifg=]] .. opts.highlights.up_to_date.fg)
    vim.cmd([[highlight PackageInfoOutdatedVersion guifg=]] .. opts.highlights.outdated.fg)

    vim.api.nvim_set_keymap(
      "n",
      "<leader>ns",
      "<cmd>lua require('package-info').show({ force = true })<cr>",
      { silent = true, noremap = true, desc = "Package info: Show dependency versions" }
    )

    vim.keymap.set({ "n" }, "<leader>nc", require("package-info").hide, {
      silent = true,
      noremap = true,
      desc = "Package info: Hide dependency versions",
    })

    vim.keymap.set({ "n" }, "<leader>nt", require("package-info").toggle, {
      silent = true,
      noremap = true,
      desc = "Package info: Toggle dependency versions",
    })
  end,
}
