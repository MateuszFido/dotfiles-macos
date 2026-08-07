return {
	{
		"carlos-algms/agentic.nvim",

		opts = {
			-- Uses the locally installed claude-agent-acp executable.
			provider = "claude-agent-acp",

			windows = {
				position = "right",
				width = "40%",
			},

			-- Review proposed edits before accepting them.
			diff_preview = {
				enabled = true,
				layout = "split",
				center_on_navigate_hunks = true,
			},
		},

		keys = {
			-- Normal mode: open or close the Agentic sidebar.
			{
				"<leader>ai",
				function()
					require("agentic").toggle({
						-- Do not automatically attach the whole current file.
						auto_add_to_context = false,
					})
				end,
				mode = "n",
				desc = "AI: Toggle Agentic",
			},

			-- Visual mode: attach exactly the selected code and focus the prompt.
			{
				"<leader>ai",
				function()
					require("agentic").add_selection({
						focus_prompt = true,
					})
				end,
				mode = "x",
				desc = "AI: Ask about selection",
			},

			-- Attach the complete current file.
			{
				"<leader>af",
				function()
					require("agentic").add_file({
						focus_prompt = true,
					})
				end,
				mode = "n",
				desc = "AI: Add current file",
			},

			-- Start a clean conversation.
			{
				"<leader>an",
				function()
					require("agentic").new_session()
				end,
				mode = { "n", "x" },
				desc = "AI: New Agentic session",
			},

			-- Restore a previous Claude session.
			{
				"<leader>as",
				function()
					require("agentic").restore_session()
				end,
				mode = "n",
				desc = "AI: Restore Agentic session",
			},
		},
	},
}
