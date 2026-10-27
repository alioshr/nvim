-- Loaded by the corral jump popup (⌘P, ~/Documents/dev/personal/corral), which
-- runs `nvim --clean`: only these mappings, no plugins. pcall: a mapping file that
-- needs a plugin must not stop the popup.
vim.g.mapleader = " "
for _, mod in ipairs({ "mappings.globals", "mappings.italian-keyboard-adapter" }) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("corral_jump: " .. mod .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end
