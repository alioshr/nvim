return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },  -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken",           -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		keys = {
			{ "<Leader>zc", ":CopilotChat<CR>",         mode = "n", desc = "Copilot - Chat with Copilot" },
			{ "<Leader>ze", ":CopilotChatExplain<CR>",  mode = "v", desc = "Copilot - Explain Code" },
			{ "<Leader>zr", ":CopilotChatReview<CR>",   mode = "v", desc = "Copilot - Review Code" },
			{ "<Leader>zf", ":CopilotChatFix<CR>",      mode = "v", desc = "Copilot - fix Code Issues" },
			{ "<Leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Copilot - Optimize Code" },
			{ "<Leader>zd", ":CopilotChatDocs<CR>",     mode = "v", desc = "Copilot - Generate Docs" },
			{ "<Leader>zt", ":CopilotChatTests<CR>",    mode = "v", desc = "Copilot - Generate Tests" },
			{ "<Leader>zm", ":CopilotChatCommit<CR>",   mode = "n", desc = "Copilot - Generate Commit Message" },
			{ "<Leader>zs", ":CopilotChatCommit<CR>",   mode = "v", desc = "Copilot - Generate Commit for Selection" },
		}

	},
}
