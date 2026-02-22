local function with_dap(callback)
  return function()
    callback(require("dap"))
  end
end

local function get_visual_selection()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return nil
  end

  lines[1] = string.sub(lines[1], start_pos[3])
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

  return table.concat(lines, "\n")
end

local function current_expression()
  local selection = get_visual_selection()
  if selection and selection ~= "" then
    return selection
  end

  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    return word
  end

  return nil
end

local function prompt_expression(prompt, default_value)
  local expression = vim.fn.input(prompt, default_value or "")
  if expression == nil or expression == "" then
    return nil
  end
  return expression
end

vim.keymap.set("n", "<Leader>dt", with_dap(function(dap)
  dap.toggle_breakpoint()
end), { desc = "Debugger: Toggle breakpoint" })

vim.keymap.set("n", "<Leader>dB", with_dap(function(dap)
  local condition = vim.fn.input("Breakpoint condition (optional): ")
  local hit_condition = vim.fn.input("Hit count (optional): ")

  condition = condition ~= "" and condition or nil
  hit_condition = hit_condition ~= "" and hit_condition or nil

  dap.toggle_breakpoint(condition, hit_condition)
end), { desc = "Debugger: Set conditional breakpoint" })

vim.keymap.set("n", "<Leader>dbc", with_dap(function(dap)
  dap.clear_breakpoints()
end), { desc = "Debugger: Clear all breakpoints" })

vim.keymap.set("n", "<Leader>dbl", with_dap(function(dap)
  dap.list_breakpoints()
end), { desc = "Debugger: List breakpoints" })

vim.keymap.set("n", "<Leader>do", function()
  require("dapui").toggle()
end, { desc = "Debugger: Toggle DAP UI" })

vim.keymap.set({ "n", "v" }, "<Leader>de", function()
  require("dapui").eval(current_expression(), { enter = false, context = "repl" })
end, { desc = "Debugger: Evaluate under cursor/selection (repl context)" })

vim.keymap.set({ "n", "v" }, "<Leader>dE", function()
  require("dapui").eval(current_expression(), { enter = false, context = "hover" })
end, { desc = "Debugger: Evaluate under cursor/selection (hover context)" })

vim.keymap.set("n", "<Leader>dx", function()
  local expression = prompt_expression("Evaluate expression: ")
  if expression then
    require("dapui").eval(expression, { enter = false, context = "repl" })
  end
end, { desc = "Debugger: Evaluate custom expression (repl context)" })

vim.keymap.set({ "n", "v" }, "<Leader>dw", function()
  local expression = current_expression() or prompt_expression("Watch expression: ")
  if expression then
    require("dapui").elements.watches.add(expression)
  end
end, { desc = "Debugger: Add watch from cursor/selection" })

vim.keymap.set("n", "<Leader>dW", function()
  local expression = prompt_expression("Watch expression: ")
  if expression then
    require("dapui").elements.watches.add(expression)
  end
end, { desc = "Debugger: Add custom watch expression" })

vim.keymap.set("n", "<Leader>dc", with_dap(function(dap)
  dap.continue()
end), { desc = "Debugger: Continue/Launch" })

vim.keymap.set("n", "<Leader>dh", "<Cmd>DebugHealth<CR>", { desc = "Debugger: Show setup health" })
