return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		cmd = "RenderMarkdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			pipe_table = { wrap = true },
		},
		keys = {
			{
				"<leader>um",
				"<cmd>RenderMarkdown toggle<cr>",
				ft = "markdown",
				desc = "Toggle Markdown rendering",
			},
		},
	},
}
