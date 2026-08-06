vim.keymap.set("n", "<leader>q", function()
	Snacks.bufdelete()
end, { desc = "Close Buffer" })

local resize_step = 2

local function neighbor(direction)
	local current = vim.fn.winnr()
	local target = vim.fn.winnr(direction)

	if target == current then
		return nil
	end

	return vim.fn.win_getid(target)
end

local function resize_in_window(win, command)
	local current = vim.api.nvim_get_current_win()

	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_set_current_win(win)
	end

	vim.cmd(command)

	if vim.api.nvim_win_is_valid(current) then
		vim.api.nvim_set_current_win(current)
	end
end

local function move_vertical_divider(direction)
	local left = neighbor("h")
	local right = neighbor("l")

	if direction == "left" then
		resize_in_window(left, "vertical resize -" .. resize_step)
	elseif right then
		resize_in_window(nil, "vertical resize +" .. resize_step)
	else
		resize_in_window(left, "vertical resize +" .. resize_step)
	end
end

local function move_horizontal_divider(direction)
	local above = neighbor("k")
	local below = neighbor("j")

	if direction == "up" then
		resize_in_window(above, "resize -" .. resize_step)
	elseif below then
		resize_in_window(nil, "resize +" .. resize_step)
	else
		resize_in_window(above, "resize +" .. resize_step)
	end
end

vim.keymap.set("n", "<C-Left>", function()
	move_vertical_divider("left")
end, { desc = "Move Divider Left" })

vim.keymap.set("n", "<C-Right>", function()
	move_vertical_divider("right")
end, { desc = "Move Divider Right" })

vim.keymap.set("n", "<C-Up>", function()
	move_horizontal_divider("up")
end, { desc = "Move Divider Up" })

vim.keymap.set("n", "<C-Down>", function()
	move_horizontal_divider("down")
end, { desc = "Move Divider Down" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float({
		scope = "line",
		border = "rounded",
		source = "if_many",
		wrap = true,
		max_width = math.max(20, math.min(100, math.floor(vim.o.columns * 0.8))),
	})
end, {
	desc = "Show line diagnostics",
})
