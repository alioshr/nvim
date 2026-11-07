-- Run: nvim --headless --clean -l tests/image-preview_spec.lua
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
package.path = config_dir .. "/lua/?.lua;" .. package.path

local preview = require("scripts.image-preview")

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

test("detects image extensions case-insensitively", function()
  eq(true, preview.is_image("/a/dark-trace.heic"))
  eq(true, preview.is_image("/a/PHOTO.JPG"))
  eq(false, preview.is_image("/a/theme.json"))
  eq(false, preview.is_image("/a/Makefile"))
end)

test("sizes chafa to the window, leaving one row free", function()
  eq({ "chafa", "--animate=off", "--size=80x23", "/x.png" }, preview.command("/x.png", 80, 24))
end)

test("never asks chafa for zero rows", function()
  eq({ "chafa", "--animate=off", "--size=10x1", "/x.png" }, preview.command("/x.png", 10, 1))
end)

if vim.fn.executable("chafa") == 1 then
  test("opening an image renders a terminal, not binary text", function()
    local png = vim.fn.tempname() .. ".png"
    vim.fn.system({ "magick", "-size", "4x4", "xc:red", png })
    preview.setup()
    vim.cmd("edit " .. png)
    vim.wait(2000, function()
      return vim.bo.buftype == "terminal"
    end)
    eq("terminal", vim.bo.buftype)
  end)
end

os.exit(failures == 0 and 0 or 1)
