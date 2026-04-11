-- UI2
require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		---@type 'cmd'|'msg' Default message target, either in the
		---cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
		---or table mapping |ui-messages| kinds and triggers to a target.
		-- targets - "cmd"
		-- targets = {
		-- 	[""] = "msg", -- Default/fallback for messages without a specific target
		-- 	empty = "cmd", -- Empty command-line state
		-- },
		-- targets = {
		-- 	[""] = "msg", -- Default/fallback for messages without a specific target
		-- 	bufwrite = "msg", -- Write/save messages
		-- 	confirm = "cmd", -- Yes/no style prompts
		-- 	emsg = "pager", -- Editor errors
		-- 	echo = "msg", -- :echo output
		-- 	echomsg = "msg", -- :echomsg output
		-- 	echoerr = "pager", -- :echoerr output
		-- 	completion = "cmd", -- Command-line completion UI
		-- 	list_cmd = "pager", -- Command listings (e.g. :autocmd)
		-- 	lua_error = "pager", -- Lua errors
		-- 	lua_print = "msg", -- Lua print() output
		-- 	progress = "pager", -- Progress output (e.g. LSP progress)
		-- 	rpc_error = "pager", -- RPC/plugin communication errors
		-- 	quickfix = "msg", -- Quickfix-type messages
		-- 	search_cmd = "cmd", -- / or ? style search cmdline
		-- 	search_count = "cmd", -- “match 3 of 10” style search count
		-- 	shell_err = "pager", -- Shell errors
		-- 	shell_out = "pager", -- Shell output
		-- 	undo = "msg", -- Undo feedback
		-- 	verbose = "pager", -- Verbose output (e.g. from :verbose)
		-- 	wmsg = "msg", -- Warning messages
		-- 	typed_cmd = "cmd", -- The typed command-line itself (e.g. :echo hi)
		-- },
		cmd = { -- Options related to messages in the cmdline window.
			height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
		},
		dialog = { -- Options related to dialog window.
			height = 0.5, -- Maximum height.
		},
		msg = { -- Options related to msg window.
			height = 0.5, -- Maximum height.
			timeout = 4000, -- Time a message is visible in the message window.
		},
		pager = { -- Options related to message window.
			height = 1, -- Maximum height.
		},
	},
})

-- vim.api.nvim_create_user_command("Veetest", function(opts)
-- 	local count = tonumber(opts.fargs[1]) or 10
-- 	for i = 1, count, 1 do
-- 		vim.notify("Test print " .. i, vim.log.levels.INFO)
-- 	end
-- end, { desc = "test print", nargs = "?" })

-- vim.opt.cmdheight = 0
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "cmd",
-- 	callback = function()
-- 		local ui2 = require("vim._core.ui2")
-- 		local win = ui2.wins and ui2.wins.cmd
-- 		if win and vim.api.nvim_win_is_valid(win) then
-- 			local cfg = vim.api.nvim_win_get_config(win)
-- 			-- local width = 40
-- 			-- local height = math.ceil(vim.o.lines * 0.5)
-- 			local width = math.min(80, math.floor(vim.o.columns * 0.8))
-- 			local height = cfg.height + 1
-- 			local row = math.floor((vim.o.lines - height) * 0.5)
-- 			local col = math.floor((vim.o.columns - width) / 2)
--
-- 			print("Adjusted cmdline window position: row=" .. row .. " col=" .. col)
-- 			print("columns", vim.o.columns, "cfg.width", cfg.width, "cfg.height", cfg.height)
-- 			print("Calculated width", width, "height", height)
--
-- 			pcall(vim.api.nvim_win_set_config, win, {
-- 				relative = "editor",
-- 				anchor = "NW",
-- 				row = row,
-- 				col = col,
-- 				width = width,
-- 				-- height = height,
-- 				border = "rounded",
-- 			})
-- 			vim.api.nvim_set_option_value(
-- 				"winhighlight",
-- 				"Normal:NormalFloat,FloatBorder:FloatBorder",
-- 				{ scope = "local", win = win }
-- 			)
-- 		end
-- 	end,
-- })

-- ## Your targets section, translated
--
--  Here is the practical meaning:
--
--  - [''] = 'msg'
--      - default/fallback message kind goes to msg
--  - empty = 'cmd'
--      - empty command-line state uses cmd
--  - bufwrite = 'msg'
--      - write/save messages go to msg
--  - confirm = 'cmd'
--      - yes/no style prompts go to cmd
--  - emsg = 'pager'
--      - editor errors go to pager
--  - echo = 'msg'
--      - :echo output goes to msg
--  - echomsg = 'msg'
--      - :echomsg goes to msg
--  - echoerr = 'pager'
--      - :echoerr goes to pager
--  - completion = 'cmd'
--      - command-line completion UI goes to cmd
--  - list_cmd = 'pager'
--      - command listings go to pager
--  - lua_error = 'pager'
--      - Lua errors go to pager
--  - lua_print = 'msg'
--      - Lua print() output goes to msg
--  - progress = 'pager'
--      - progress output goes to pager
--  - rpc_error = 'pager'
--      - RPC/plugin communication errors go to pager
--  - quickfix = 'msg'
--      - quickfix-type messages go to msg
--  - search_cmd = 'cmd'
--      - / or ? style search cmdline goes to cmd
--  - search_count = 'cmd'
--      - “match 3 of 10” style search count goes to cmd
--  - shell_err = 'pager'
--      - shell errors go to pager
--  - shell_out = 'pager'
--      - shell output goes to pager
--  - undo = 'msg'
--      - undo feedback goes to msg
--  - verbose = 'pager'
--      - verbose output goes to pager
--  - wmsg = 'msg'
--      - warning messages go to msg
--  - typed_cmd = 'cmd'
--      - the typed command-line itself goes to cmd
