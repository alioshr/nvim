return {
  "niba/continue.nvim",
  lazy = false,
  config = true,

  ---@module "continue"
  ---@type Continue.Config
  opts = {
    picker = "telescope",
    use_git_host = false, -- use cwd instead of git remote host to avoid race condition on cold boot
  },
}
