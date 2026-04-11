local map = vim.keymap.set

-- cnorev

-- Basic keymap
map("i", "jk", "<ESC>")
map("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
-- map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
-- map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
-- map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
-- map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map("n", "<C-s>", "<cmd>w<cr>", { desc = "file save" })
map("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "file save" })

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Nvim Tree" })
-- map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Focus Nvim Tree" })

-- Buffers
map("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })
map("n", "<leader>sq", ":only<CR>", { desc = "Close all other splits" })
map("n", "<leader>x", ":bd<CR>", { desc = "Close current buffers" })
map("n", "<leader>X", ":%bd<CR>", { desc = "Close all buffers" })
map("n", "<Tab>", ":bnext<CR>", { desc = "Next Buffer" })
map("n", "<S-Tab>", ":bNext<CR>", { desc = "Prev Buffer" })

-- LuaSnip Cancel
map("n", "<Leader>lu", function()
	require("luasnip").unlink_current()
end, { desc = "LuaSnip Unlink Current" })

-- Lazygit
map("n", "<Leader>lg", ":LazyGit<CR>", { desc = "LazyGit" })

-- undotree
map("n", "<leader>u", function()
	require("undotree").open({
		command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
	})
end, { desc = "Undotree toggle" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
-- map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
-- map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "telescope diagnostics" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

-- Treesitter objects
-- ============================================================================
-- Selection (Visual & Operator-pending)

local ts_select = require("nvim-treesitter-textobjects.select")

map({ "x", "o" }, "af", function()
	ts_select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select around function" })

map({ "x", "o" }, "if", function()
	ts_select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select inside function" })

map({ "x", "o" }, "ac", function()
	ts_select.select_textobject("@class.outer", "textobjects")
end, { desc = "Select around class" })

map({ "x", "o" }, "ic", function()
	ts_select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select inside class" })

map({ "x", "o" }, "as", function()
	ts_select.select_textobject("@local.scope", "locals")
end, { desc = "Select scope" })

map({ "x", "o" }, "ia", function()
	ts_select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Select inside argument" })

map({ "x", "o" }, "aa", function()
	ts_select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Select around argument" })

-- Swap
local ts_swap = require("nvim-treesitter-textobjects.swap")

map("n", "<leader>a", function()
	ts_swap.swap_next("@parameter.inner")
end, { desc = "Swap parameter next" })

map("n", "<leader>A", function()
	ts_swap.swap_previous("@parameter.outer")
end, { desc = "Swap parameter previous" })

-- Movement (Next)
local ts_move = require("nvim-treesitter-textobjects.move")

map({ "n", "x", "o" }, "]f", function()
	ts_move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })

map({ "n", "x", "o" }, "]]", function()
	ts_move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })

map({ "n", "x", "o" }, "]o", function()
	ts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end, { desc = "Next loop" })

map({ "n", "x", "o" }, "]s", function()
	ts_move.goto_next_start("@local.scope", "locals")
end, { desc = "Next scope" })

map({ "n", "x", "o" }, "]z", function()
	ts_move.goto_next_start("@fold", "folds")
end, { desc = "Next fold" })

map({ "n", "x", "o" }, "]F", function()
	ts_move.goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })

map({ "n", "x", "o" }, "][", function()
	ts_move.goto_next_end("@class.outer", "textobjects")
end, { desc = "Next class end" })

map({ "n", "x", "o" }, "]a", function()
	ts_move.goto_next_start("@parameter.inner", "textobjects")
end, { desc = "Next argument start" })

-- Movement (Previous)
map({ "n", "x", "o" }, "[f", function()
	ts_move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Prev function start" })

map({ "n", "x", "o" }, "[[", function()
	ts_move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Prev class start" })

map({ "n", "x", "o" }, "[F", function()
	ts_move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "Prev function end" })

map({ "n", "x", "o" }, "[]", function()
	ts_move.goto_previous_end("@class.outer", "textobjects")
end, { desc = "Prev class end" })

map({ "n", "x", "o" }, "[a", function()
	ts_move.goto_previous_start("@parameter.inner", "textobjects")
end, { desc = "Prev argument start" })

-- Conditionals
map({ "n", "x", "o" }, "]c", function()
	ts_move.goto_next("@conditional.outer", "textobjects")
end, { desc = "Next conditional" })

map({ "n", "x", "o" }, "[c", function()
	ts_move.goto_previous("@conditional.outer", "textobjects")
end, { desc = "Prev conditional" })

-- Repeatable Move Logic
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat move forward" })
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat move backward" })

-- Markdown Keymaps
map("n", "<leader>mdt", ":Markview toggle<CR>", { desc = "Toggle Markview" })
map("n", "<leader>mds", ":Markview splitToggle<CR>", { desc = "Toggle Markview Split" })
map("n", "<leader>mda", ":Markview attach<CR>", { desc = "Attach Markview to current buffer" })

vim.notify("5_Mappings loaded", vim.log.levels.INFO)
