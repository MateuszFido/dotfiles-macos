return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				-- End-of-line diagnostic text cannot properly wrap.
				virtual_text = false,

				-- Preserve LazyVim's signs, underlines, sorting, and icons.
				float = {
					border = "rounded",
					source = "if_many",
					wrap = true,
				},
			},
		},
	},
}
