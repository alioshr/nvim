return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ '<leader>et', '<cmd>NvimTreeToggle<cr>' },
		{ '<leader>ef', '<cmd>NvimTreeFocus<cr>' },
		{ '<leader>eo', '<cmd>NvimTreeFindFile<cr>' },
	},
	config = function()
		require("nvim-tree").setup {}
	end,
}
