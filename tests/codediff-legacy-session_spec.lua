-- Run: nvim --headless --clean -l tests/codediff-legacy-session_spec.lua
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local codediff_dir = vim.fn.stdpath("data") .. "/lazy/codediff.nvim"
package.path = table.concat({
  config_dir .. "/lua/?.lua",
  codediff_dir .. "/lua/?.lua",
  package.path,
}, ";")

local shim = require("scripts.codediff-legacy-session")
local path = require("codediff.core.path")

local failures = 0
local function test(name, fn)
  local ok, err = pcall(fn)
  print((ok and "ok   " or "FAIL ") .. name .. (ok and "" or ("\n     " .. tostring(err))))
  if not ok then
    failures = failures + 1
  end
end

local function eq(expected, actual)
  assert(vim.deep_equal(expected, actual), "expected " .. vim.inspect(expected) .. ", got " .. vim.inspect(actual))
end

test("converts legacy explorer config to panel + empty paths", function()
  local status = { unstaged = {}, staged = {} }
  local cfg = shim.normalize({
    mode = "explorer",
    git_root = "/repo",
    original_path = "",
    modified_path = "",
    explorer_data = { status_result = status, focus_file = "a.lua" },
  }, path)

  eq({ name = "explorer", data = { status_result = status, focus_file = "a.lua" } }, cfg.panel)
  eq(path.empty(), cfg.original)
  eq(path.empty(), cfg.modified)
  eq(nil, cfg.mode)
  eq(nil, cfg.explorer_data)
  eq(nil, cfg.original_path)
end)

test("explorer without explorer_data gets empty panel data", function()
  local cfg = shim.normalize({ mode = "explorer", git_root = "/repo" }, path)
  eq({ name = "explorer", data = {} }, cfg.panel)
  eq(path.empty(), cfg.original)
end)

test("converts legacy conflict (standalone) config to Path refs", function()
  local cfg = shim.normalize({
    mode = "standalone",
    git_root = "/repo",
    original_path = "src/a.lua",
    modified_path = "src/a.lua",
    original_revision = ":3",
    modified_revision = ":2",
    conflict = true,
  }, path)

  eq(nil, cfg.panel)
  eq({ relative = "src/a.lua", absolute = "/repo/src/a.lua" }, cfg.original)
  eq({ relative = "src/a.lua", absolute = "/repo/src/a.lua" }, cfg.modified)
  eq(true, cfg.conflict)
  eq(":3", cfg.original_revision)
end)

test("converts legacy history config", function()
  local cfg = shim.normalize({ mode = "history", history_data = { commits = { "abc" } } }, path)
  eq({ name = "history", data = { commits = { "abc" } } }, cfg.panel)
end)

test("leaves new-shape configs untouched", function()
  local panel = { name = "explorer", data = {} }
  local original = path.empty()
  local input = { panel = panel, git_root = "/repo", original = original, modified = path.empty() }
  local cfg = shim.normalize(input, path)
  assert(cfg == input and cfg.panel == panel and cfg.original == original, "config was changed")
end)

test("does not overwrite existing new fields on mixed configs", function()
  local panel = { name = "explorer", data = { x = 1 } }
  local cfg = shim.normalize({ mode = "explorer", panel = panel, explorer_data = { y = 2 } }, path)
  assert(cfg.panel == panel, "panel was replaced")
  eq(nil, cfg.mode)
end)

test("install wraps view.create once and normalizes arguments", function()
  local received
  local fake_view = {
    create = function(cfg, ft)
      received = { cfg = cfg, ft = ft }
      return "created"
    end,
  }
  package.loaded["codediff.ui.view"] = fake_view

  shim.install()
  local wrapped = fake_view.create
  shim.install()
  assert(fake_view.create == wrapped, "install is not idempotent")

  local result = fake_view.create({ mode = "explorer", git_root = "/repo", explorer_data = {} }, "lua")
  eq("created", result)
  eq("lua", received.ft)
  eq("explorer", received.cfg.panel.name)
  eq(path.empty(), received.cfg.original)
end)

if failures > 0 then
  print(failures .. " test(s) failed")
  os.exit(1)
end
print("all tests passed")
