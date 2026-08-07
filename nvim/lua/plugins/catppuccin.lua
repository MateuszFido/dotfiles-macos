return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,

		opts = {
			flavour = "mocha",
			transparent_background = false,

			-- Keep Catppuccin's syntax colours, but remove the blue tint
			-- from backgrounds and neutral UI colours.
			color_overrides = {
				mocha = {
					text = "#dcdcdc",
					subtext1 = "#c6c6c6",
					subtext0 = "#aaaaaa",

					overlay2 = "#8a8a8a",
					overlay1 = "#707070",
					overlay0 = "#585858",

					surface2 = "#343434",
					surface1 = "#282828",
					surface0 = "#1b1b1b",

					base = "#111318",
					mantle = "#050505",
					crust = "#000000",
				},
			},
		},
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}
