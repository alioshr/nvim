-- Open image files as a chafa render instead of raw binary text.
local M = {}

M.extensions = { "png", "jpg", "jpeg", "gif", "webp", "bmp", "tiff", "heic", "heif", "avif", "ico", "svg" }

function M.is_image(path)
  local ext = vim.fn.fnamemodify(path, ":e"):lower()
  return vim.tbl_contains(M.extensions, ext)
end

-- Build the chafa command for a window of `cols` x `rows` cells.
function M.command(path, cols, rows)
  return { "chafa", "--animate=off", "--size=" .. cols .. "x" .. math.max(rows - 1, 1), path }
end

local function render(buf, path)
  local win = vim.fn.bufwinid(buf)
  if win == -1 or vim.bo[buf].buftype == "terminal" then
    return
  end
  vim.bo[buf].modified = false
  vim.api.nvim_buf_call(buf, function()
    vim.fn.jobstart(M.command(path, vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)), { term = true })
  end)
end

function M.setup()
  if vim.fn.executable("chafa") == 0 then
    return
  end
  local patterns = vim.tbl_map(function(ext)
    return "*." .. ext
  end, M.extensions)
  vim.list_extend(patterns, vim.tbl_map(string.upper, patterns))

  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = vim.api.nvim_create_augroup("image_preview", { clear = true }),
    pattern = patterns,
    callback = function(args)
      local path = vim.fn.fnamemodify(args.file, ":p")
      local buf = args.buf
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].bufhidden = "wipe"
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          render(buf, path)
        end
      end)
    end,
  })
end

return M
