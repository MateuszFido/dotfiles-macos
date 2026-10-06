return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		ft = "markdown",
		cmd = "Obsidian",
		dependencies = { "folke/snacks.nvim" },
		opts = function()
			return {
				legacy_commands = false,
				workspaces = {
					{ name = "vault", path = vim.env.OBSIDIAN_VAULT or vim.fn.expand("~/Nextcloud/vault") },
				},
				picker = { name = "snacks.picker" },
				note_id_func = require("obsidian.builtin").title_id,
				-- render-markdown.nvim already handles the note display.
				ui = { enable = false },
				-- Match Obsidian's current daily-note defaults: vault root, YYYY-MM-DD.
				daily_notes = { date_format = "YYYY-MM-DD" },
			}
		end,
		keys = {
			{ "<leader>od", "<cmd>Obsidian today<cr>", desc = "Today's note" },
			{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
			{ "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
			{ "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search note text" },
			{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show backlinks" },
			{ "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>o", group = "Obsidian" },
			},
		},
	},
}
