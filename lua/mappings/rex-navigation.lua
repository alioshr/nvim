-- ctrl+h/j/k/l: move between splits; at the last split, Rex moves to the next pane.
-- Rex sends these keys to nvim (~/.config/rex/init.lua), as vim-tmux-navigator did.

local function rex_focus(direction)
  local session = vim.env.REX_SESSION
  if not session or session == "" then
    return
  end
  vim.system({
    "rex",
    "do",
    "-s",
    session,
    "-e",
    ('rex.session.focus_direction{ direction = "%s" }'):format(direction),
  })
end

local directions = { h = "left", j = "down", k = "up", l = "right" }

for key, direction in pairs(directions) do
  vim.keymap.set("n", "<C-" .. key .. ">", function()
    local before = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    if vim.api.nvim_get_current_win() == before then
      rex_focus(direction)
    end
  end, { desc = "Go to the split or Rex pane " .. direction })
end
