local state = { floating = { buf = -1, win = -1 } }

local function toggle_terminal()
	if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_hide(state.floating.win)
		return
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	if not vim.api.nvim_buf_is_valid(state.floating.buf) then
		state.floating.buf = vim.api.nvim_create_buf(false, false)
	end

	state.floating.win = vim.api.nvim_open_win(state.floating.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[state.floating.win].number = false
	vim.wo[state.floating.win].relativenumber = false
	vim.wo[state.floating.win].signcolumn = "no"

	vim.api.nvim_win_call(state.floating.win, function()
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd("terminal")
		end
		vim.cmd("startinsert")
	end)
end

vim.keymap.set({ "n", "t" }, "<A-i>", toggle_terminal, { desc = "Toggle Floating Terminal" })
