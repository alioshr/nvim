return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				ts_ls = {},
				eslint = {},
				tailwindcss = {},
			},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "eslint", "ts_ls", "tailwindcss" },
			})

			vim.lsp.enable('lua_ls')
			vim.lsp.enable('eslint')
			vim.lsp.enable('ts_ls')
			vim.lsp.enable('tailwindcss')

			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				lspconfig[server].setup(config)
			end
		end,
	}
}
