vim.pack.add({
	-- requires own file for setup
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/catppuccin/nvim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/kcayme/bearded-arc.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/kdheepak/lazygit.nvim",
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
	-- "https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/L3MON4D3/LuaSnip",

	-- TODO: add later
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",

	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

	-- activate default here
	"https://github.com/williamboman/mason.nvim.git",
	"https://github.com/mason-org/mason-lspconfig.nvim",

	-- Ai
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/copilotlsp-nvim/copilot-lsp",
	"https://github.com/AndreM222/copilot-lualine",
	"https://github.com/carlos-algms/agentic.nvim",
})

-- nvim builtin
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- default setup
require("mason").setup()

require("mason-lspconfig").setup({
	-- automatic_enable = false,
	-- automatic_enable = {
	-- 	"lua_ls",
	-- 	"vimls",
	-- 	exclude = {
	-- 		"rust_analyzer",
	-- 		"ts_ls",
	-- 	},
	-- },
})

-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme("tokyonight-moon")

-- Theme
require("bearded-arc").setup({
	plugins = {
		all = true,
	},
	transparent = true,
	-- styles = {
	-- 	-- keywords = { italic = true },
	-- 	comments = { italic = true },
	-- 	-- functions = { bold = true },
	-- },
	-- on_highlights = function(hl, c)
	-- borderless Telescope
	-- hl.TelescopeNormal = { fg = c.fg, bg = c.bg_dark }
	-- hl.TelescopeBorder = { fg = c.bg_dark, bg = c.bg_dark }
	-- hl.TelescopePromptNormal = { fg = c.fg, bg = c.bg_popup }
	-- hl.TelescopePromptBorder = { fg = c.bg_popup, bg = c.bg_popup }
	-- hl.TelescopePromptTitle = { fg = c.bg, bg = c.blue, bold = true }
	-- hl.TelescopePreviewTitle = { fg = c.bg, bg = c.green, bold = true }
	-- hl.TelescopeResultsTitle = { fg = c.bg_dark, bg = c.bg_dark }
	-- brighter line number
	-- hl.LineNr = { fg = c.fg_muted }
	-- hl.CursorLineNr = { fg = c.yellow, bold = true }
	-- end,
})
vim.cmd.colorscheme("bearded-arc")

-- Treesitter
local ts = require("nvim-treesitter")

-- ts.setup({})

local ts_languages = {
	-- Core / Neovim
	"vim",
	"vimdoc",
	"lua",

	-- Web
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx", -- React / JSX / TSX

	-- Systems
	"c",
	"cpp",
	"java",

	-- Shell / DevOps
	"bash",
	"dockerfile",

	-- Docs / config
	"markdown",
	"markdown_inline",
	"json",
	"yaml",
}

ts.install(ts_languages)

-- Enable Highlighting and Indent v0.12
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype

		-- 1. Check if a Treesitter parser exists for this filetype
		local lang = vim.treesitter.language.get_lang(ft)

		if lang then
			-- 2. Only start Treesitter if the parser is found
			-- This prevents the "NvimTree" parser error
			local ok, err = pcall(vim.treesitter.start, bufnr, lang)

			if ok then
				-- 3. Enable folding ONLY for files with Treesitter active
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				vim.wo.foldlevel = 99

				-- 4. Enable indentation logic
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		else
			-- Optional: Fallback for files without TS (like NvimTree or plain text)
			-- We do nothing here, letting Neovim use default regex highlighting
		end
	end,
})

-- treesitter textobject
require("nvim-treesitter-textobjects").setup({
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "<c-v>", -- blockwise
		},
	},
	-- If you set this to `true` (default is `false`) then any textobject is
	-- extended to include preceding or succeeding whitespace. Succeeding
	-- whitespace has priority in order to act similarly to eg the built-in
	-- `ap`.
	--
	-- Can also be a function which gets passed a table with the keys
	-- * query_string: eg '@function.inner'
	-- * selection_mode: eg 'v'
	-- and should return true of false
	include_surrounding_whitespace = false,
	move = {
		-- whether to set jumps in the jumplist
		set_jumps = true,
	},
})

-- Conform
local cf = require("conform")

cf.setup({
	formatters_by_ft = {
		-- Lua (Config)
		lua = { "stylua" },

		-- Web (Prettierd)
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		json = { "prettierd" },
		markdown = { "prettierd" },
		yaml = { "prettierd" },

		-- Systems & DevOps (42KL + bumIntra)
		xml = { "xmlformat" },
		sh = { "shfmt" },
		nginx = { "nginxfmt" },
		cpp = { "clang_format" },
		c = { "clang_format" }, -- Un-commented this for your 42 projects
		java = { "google_java_format" }, -- Un-commented this for your Java work
	},

	-- Customizing your specific formatters
	formatters = {
		google_java_format = {
			command = "google-java-format",
			args = { "-" },
			stdin = true,
		},
		xmlformat = {
			args = { "--indent", "4", "-" },
		},
	},

	-- Triggering the format on save
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 500,
	},
})

-- lazydev
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

-- blink-cmp
local blinkcmp = require("blink-cmp")

blinkcmp.setup({
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},

	completion = {
		list = {
			selection = {
				preselect = true,
				auto_insert = true,
			},
		},
		menu = {
			-- border = "rounded",
			draw = {
				columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
			},
		},
		documentation = {
			auto_show = true,
			window = { border = "rounded" },
		},
	},

	signature = {
		enabled = true,
	},

	snippets = { preset = "luasnip" },

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

local function build_blink(params)
	vim.notify("Building blink.cmp...", vim.log.levels.INFO)

	-- We remove :wait() and add an 'on_exit' callback instead
	vim.system({ "cargo", "build", "--release" }, { cwd = params.path }, function(obj)
		vim.schedule(function() -- Schedule back to main thread for UI updates
			if obj.code == 0 then
				vim.notify("Building blink.cmp done!", vim.log.levels.INFO)
			else
				vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
			end
		end)
	end)
end

vim.api.nvim_create_user_command("BlinkBuild", function()
	local path = vim.fn.expand("$HOME/.local/share/nvim/site/pack/core/opt/blink.cmp")
	build_blink({ path = path })
end, { desc = "Build blink.cmp" })

-- Nvim-Tree
local status, nt = pcall(require, "nvim-tree")

if not status then
	print("Error: nvim-tree plugin not found in runtime path!")
	return
end

nt.setup({
	on_attach = "default",
	hijack_cursor = true,
	auto_reload_on_write = true,
	disable_netrw = true,
	hijack_netrw = true,
	hijack_unnamed_buffer_when_opening = false,
	root_dirs = {},
	prefer_startup_root = false,
	sync_root_with_cwd = false,
	reload_on_bufenter = false,
	respect_buf_cwd = false,
	select_prompts = false,
	sort = {
		sorter = "name",
		folders_first = true,
		files_first = false,
	},
	view = {
		centralize_selection = true,
		cursorline = true,
		cursorlineopt = "both",
		debounce_delay = 15,
		side = "left",
		preserve_window_proportions = true,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
		width = {
			min = 30,
			max = -1,
		},
		float = {
			enable = false,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			},
		},
	},
	renderer = {
		add_trailing = false,
		group_empty = true,
		full_name = false,
		root_folder_label = ":~:s?$?/..?",
		indent_width = 2,
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		hidden_display = "none",
		symlink_destination = true,
		decorators = { "Git", "Open", "Hidden", "Modified", "Bookmark", "Diagnostics", "Copied", "Cut" },
		highlight_git = "none",
		highlight_diagnostics = "none",
		highlight_opened_files = "none",
		highlight_modified = "none",
		highlight_hidden = "none",
		highlight_bookmarks = "none",
		highlight_clipboard = "name",
		indent_markers = {
			enable = false,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
		icons = {
			web_devicons = {
				file = {
					enable = true,
					color = true,
				},
				folder = {
					enable = false,
					color = true,
				},
			},
			git_placement = "before",
			modified_placement = "after",
			hidden_placement = "after",
			diagnostics_placement = "signcolumn",
			bookmarks_placement = "signcolumn",
			padding = {
				icon = " ",
				folder_arrow = " ",
			},
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
				modified = true,
				hidden = false,
				diagnostics = true,
				bookmarks = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				bookmark = "󰆤",
				modified = "●",
				hidden = "󰜌",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	update_focused_file = {
		enable = true,
		update_root = {
			enable = false,
			ignore_list = {},
		},
		exclude = false,
	},
	system_open = {
		cmd = "",
		args = {},
	},
	git = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		disable_for_dirs = {},
		timeout = 400,
		cygwin_support = false,
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		show_on_open_dirs = true,
		debounce_delay = 500,
		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
		diagnostic_opts = false,
	},
	modified = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},
	filters = {
		enable = true,
		git_ignored = false,
		dotfiles = false,
		git_clean = false,
		no_buffer = false,
		no_bookmark = false,
		custom = {},
		exclude = {},
	},
	live_filter = {
		prefix = "[FILTER]: ",
		always_show_folders = true,
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
		max_events = 0,
		ignore_dirs = {
			"/.ccls-cache",
			"/build",
			"/node_modules",
			"/target",
			"/.zig-cache",
		},
		whitelist_dirs = {},
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = true,
			eject = true,
			resize_window = true,
			relative_path = true,
			window_picker = {
				enable = true,
				picker = "default",
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
		remove_file = {
			close_window = true,
		},
	},
	trash = {
		cmd = "gio trash",
	},
	tab = {
		sync = {
			open = false,
			close = false,
			ignore = {},
		},
	},
	notify = {
		threshold = vim.log.levels.INFO,
		absolute_path = true,
	},
	help = {
		sort_by = "key",
	},
	ui = {
		confirm = {
			remove = true,
			trash = true,
			default_yes = false,
		},
	},
	bookmarks = {
		persist = false,
	},
	experimental = {},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			dev = false,
			diagnostics = false,
			git = false,
			profile = false,
			watcher = false,
		},
	},
})

-- Whichkey
local wk = require("which-key")

wk.setup({
	-- Basic vanilla setup
	preset = "classic",
	delay = 300, -- Shows up after 0.5 seconds of hesitation
	win = {
		no_overlap = false,
		-- border = "rounded",
		-- width = 1,
		-- height = { min = 4, max = 25 },
		-- col = 0,
		-- row = math.huge,
		-- border = "none",
	},
	-- layout = {
	-- },
})

-- nvim-telescope
local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			n = { ["q"] = require("telescope.actions").close },
		},
		layout_strategy = "flex",
		layout_config = {
			-- Shared options
			width = 0.9,
			height = 0.8,
			prompt_position = "top",

			-- Unique 'flex' options
			flip_columns = 120, -- Switch to horizontal if width > 120 columns

			horizontal = {
				mirror = false,
				preview_width = 0.6,
			},
			vertical = {
				mirror = true, -- Flip results and preview locations in vertical mode
			},
		},
		sorting_strategy = "ascending",
	},
})

-- tiny-inline-diagnostic
require("tiny-inline-diagnostic").setup({
	preset = "modern",
	vim.diagnostic.config({ virtual_text = false }),
})

-- nvim-autopairs
require("nvim-autopairs").setup({
	check_ts = true,
	fast_wrap = {},
})

-- nvim-ts-autotag
require("nvim-ts-autotag").setup({})

-- rainbow-delimiters
require("rainbow-delimiters.setup").setup({
	strategy = {
		[""] = "rainbow-delimiters.strategy.global",
		vim = "rainbow-delimiters.strategy.local",
	},
	query = {
		[""] = "rainbow-delimiters",
		lua = "rainbow-blocks",
	},
	priority = {
		[""] = 110,
		lua = 210,
	},
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterOrange",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
	},
})

-- indent-blankline
-- local hooks = require("ibl.hooks")
--
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
-- 	vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b3d4a", blend = 85 })
--
-- 	vim.api.nvim_set_hl(0, "IblScope", { fg = "#ffffff", blend = 10, bold = true })
-- end)
--
-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
--
-- require("ibl").setup({
-- 	indent = {
-- 		-- char = "▎",
-- 		-- highlight = { "IblIndent" },
-- 	},
-- 	scope = {
-- 		-- enabled = true,
-- 		char = "▎",
-- 		highlight = { "IblScope" },
-- 		show_start = false,
-- 		show_end = false,
-- 		-- injected_languages = false,
-- 	},
-- 	exclude = {
-- 		filetypes = { "help", "nvimtree", "lazy", "mason", "notify" },
-- 	},
-- })

-- lualine
local mode_map = {
	["n"] = "󰭩 N",
	["i"] = "󰏫 I",
	["v"] = "󰈈 V",
	["V"] = "󰈈 VL",
	["c"] = "󰘳 C",
	["no"] = "󰭩 N?",
	["s"] = "󰛔 S",
	["S"] = "󰛔 SL",
	["ic"] = "󰏫 I",
	["R"] = "󰛔 R",
	["Rv"] = "󰛔 VR",
	["cv"] = "󰘳 VE",
	["ce"] = "󰘳 EX",
	["r"] = "󰛔 P",
	["rm"] = "󰛔 M",
	["r?"] = "󰛔 C",
	["!"] = "󰘳 SH",
	["t"] = "󰘳 T",
}

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "everforest",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function()
					return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
				end,
				-- color = { gui = "bold" },
			},
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "buffers", mode = 4, hide_filename_extension = true } },
		lualine_x = { { "copilot", show_colors = true }, "lsp_status", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- luasnip
require("luasnip").setup({
	update_events = { "TextChanged", "TextChangedI" },
})
require("luasnip.loaders.from_vscode").lazy_load()

-- Copilot lua
require("copilot").setup({
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
		layout = {
			position = "bottom", -- | top | left | right | bottom |
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		hide_during_completion = true,
		debounce = 15,
		trigger_on_accept = true,
		keymap = {
			accept = "<M-l>",
			accept_word = "<M-w>",
			accept_line = "<M-a>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
			toggle_auto_trigger = "<M-t>",
		},
	},
	nes = {
		enabled = false, -- requires copilot-lsp as a dependency
		auto_trigger = false,
		keymap = {
			accept_and_goto = false,
			accept = false,
			dismiss = false,
		},
	},
	auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
	logger = {
		file = vim.fn.stdpath("log") .. "/copilot-lua.log",
		file_log_level = vim.log.levels.OFF,
		print_log_level = vim.log.levels.WARN,
		trace_lsp = "off", -- "off" | "debug" | "verbose"
		trace_lsp_progress = false,
		log_lsp_messages = false,
	},
	copilot_node_command = "node", -- Node.js version must be > 22
	workspace_folders = {},
	copilot_model = "",
	disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
	root_dir = function()
		return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
	end,
	should_attach = function(buf_id, _)
		if not vim.bo[buf_id].buflisted then
			-- logger.debug("not attaching, buffer is not 'buflisted'")
			return false
		end

		if vim.bo[buf_id].buftype ~= "" then
			-- logger.debug("not attaching, buffer 'buftype' is " .. vim.bo[buf_id].buftype)
			return false
		end

		return true
	end,
	server = {
		type = "nodejs", -- "nodejs" | "binary"
		custom_server_filepath = nil,
	},
	server_opts_overrides = {
		offset_encoding = "utf-16",
	},
	filetypes = {
		markdown = true, -- overrides default
		terraform = false, -- disallow specific filetype
		-- AgenticInput = true,
		sh = function()
			if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
				-- disable for .env files
				return false
			end
			return true
		end,
	},
})

-- UI2
require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		---@type 'cmd'|'msg' Default message target, either in the
		---cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
		---or table mapping |ui-messages| kinds and triggers to a target.
		targets = cmd,
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

vim.api.nvim_create_user_command("Veetest", function(opts)
	local count = tonumber(opts.fargs[1]) or 10
	for i = 1, count, 1 do
		vim.notify("Test print " .. i, vim.log.levels.INFO)
	end
end, { desc = "test print", nargs = "?" })

vim.notify("2_Plugins loaded", vim.log.levels.INFO)
