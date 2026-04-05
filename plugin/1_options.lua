-- ============================================================================
-- 1_Options.lua - Basic Settings & Editor Behavior
-- ============================================================================

-- ⌨️ Leader Key
vim.g.mapleader = " "

-- 🎨 UI Appearance
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Set to true if you prefer relative jumps
vim.opt.cursorline = true -- Highlight the current line
vim.opt.cursorlineopt = "number" -- Only highlight the number for a cleaner look
vim.opt.termguicolors = true -- 24-bit RGB colors for that G14 OLED/High-end screen
vim.opt.signcolumn = "yes" -- Keep gutter fixed to prevent UI "jumping"
vim.opt.showmode = false -- Hide mode (e.g. -- INSERT --) as Statusline handles it
vim.opt.ruler = false -- Hide default ruler to save space

-- ⌨️ Editing & Indentation (42 Norminette friendly)
vim.opt.tabstop = 4 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces for auto-indent
vim.opt.softtabstop = 4 -- Makes Tab/Backspace feel like 4 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart auto-indent (C-style)
vim.opt.autoindent = true -- Copy indent from previous line
vim.opt.wrap = false -- Do not wrap long lines

-- 🔍 Search Behavior
vim.opt.ignorecase = true -- Case-insensitive search...
vim.opt.smartcase = true -- ...unless search contains a capital letter
vim.opt.hlsearch = true -- Highlight all matches
vim.opt.incsearch = true -- Show matches as you type

-- 🚀 Performance & Stability
vim.opt.updatetime = 250 -- Faster LSP/Git feedback (default is 4000ms)
vim.opt.timeoutlen = 400 -- Time to wait for mapped sequence to complete
vim.opt.undofile = true -- Persistent undo history across sessions
vim.opt.redrawtime = 5000 -- Allow more time for syntax highlighting on big files
vim.opt.maxmempattern = 20000 -- Allow more memory for complex regex patterns
vim.opt.swapfile = true -- Enable swap files for crash recovery
vim.opt.backup = false -- Disable backup files (optional, can be enabled if desired)
vim.opt.writebackup = true -- Enable backup before overwriting a file

-- 🖱️ Navigation Padding (Essential for 14" screen splits)
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- Keep 10 columns to left/right of cursor

-- 📋 System Integration
vim.opt.clipboard = "unnamedplus" -- Sync with Windows/System clipboard

-- Filetype Detection & Plugins
vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})

-- 🛡️ Provider Optimization (Speeds up startup)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog = vim.fn.expand("~/.venv/bin/python3")

-- 📂 Disable Netrw (Highly recommended for NvimTree/Oil users)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 📢 Load Confirmation
vim.notify("1_Options loaded", vim.log.levels.INFO)
