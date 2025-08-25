local tests = require("lua.scripts.tests-javascript")

-- Test runner key mappings
vim.keymap.set("n", "<leader>tv", tests.runVitestTest, { desc = "Run Vitest on current file" })
vim.keymap.set("n", "<leader>tj", tests.runJestTest, { desc = "Run Jest on current file" })
vim.keymap.set("n", "<leader>tc", tests.runCracoTest, { desc = "Run Craco test on current file" })

