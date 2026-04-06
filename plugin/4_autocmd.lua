local api = vim.api

local plugins = {}
local mason_catalog = {
	clangd = { category = "LSP Servers", type = "LSP", languages = "C, C++, Objective-C, Objective-C++", used = "Yes" },
	["css-lsp"] = { category = "LSP Servers", type = "LSP", languages = "CSS", used = "Yes" },
	["docker-compose-language-service"] = {
		category = "LSP Servers",
		type = "LSP",
		languages = "Docker Compose YAML",
		used = "No",
	},
	["docker-language-server"] = { category = "LSP Servers", type = "LSP", languages = "Docker ecosystem", used = "No" },
	["dockerfile-language-server"] = { category = "LSP Servers", type = "LSP", languages = "Dockerfile", used = "No" },
	["html-lsp"] = { category = "LSP Servers", type = "LSP", languages = "HTML", used = "Yes" },
	jdtls = { category = "LSP Servers", type = "LSP", languages = "Java", used = "Yes" },
	["lua-language-server"] = { category = "LSP Servers", type = "LSP", languages = "Lua", used = "Yes" },
	["nginx-language-server"] = { category = "LSP Servers", type = "LSP", languages = "Nginx config", used = "No" },
	pyright = { category = "LSP Servers", type = "LSP", languages = "Python", used = "Yes" },
	["tailwindcss-language-server"] = {
		category = "LSP Servers",
		type = "LSP",
		languages = "Tailwind CSS, HTML, CSS, JavaScript, TypeScript",
		used = "Yes",
	},
	tsgo = {
		category = "LSP Servers",
		type = "LSP",
		languages = "JavaScript, JavaScript React, TypeScript, TypeScript React",
		used = "Yes",
	},
	biome = {
		category = "Formatters",
		type = "Formatter",
		languages = "JavaScript, TypeScript, JSON, CSS, and more",
		used = "No",
	},
	["clang-format"] = { category = "Formatters", type = "Formatter", languages = "C, C++", used = "Yes" },
	["google-java-format"] = { category = "Formatters", type = "Formatter", languages = "Java", used = "Yes" },
	["nginx-config-formatter"] = { category = "Formatters", type = "Formatter", languages = "Nginx config", used = "Yes" },
	prettierd = {
		category = "Formatters",
		type = "Formatter",
		languages = "JavaScript, JavaScript React, TypeScript, TypeScript React, HTML, CSS, JSON, Markdown, YAML",
		used = "Yes",
	},
	shfmt = { category = "Formatters", type = "Formatter", languages = "Shell", used = "Yes" },
	stylua = { category = "Formatters", type = "Formatter", languages = "Lua", used = "Yes" },
	xmlformatter = { category = "Formatters", type = "Formatter", languages = "XML", used = "Yes" },
	eslint_d = { category = "Linters", type = "Linter", languages = "JavaScript, TypeScript", used = "No" },
	flake8 = { category = "Linters", type = "Linter", languages = "Python", used = "No" },
	codelldb = { category = "Debugger / DAP", type = "Debugger", languages = "C, C++, Rust", used = "No" },
	["copilot-language-server"] = {
		category = "AI",
		type = "AI",
		languages = "General completion / Copilot",
		used = "Indirect",
	},
	["tree-sitter-cli"] = {
		category = "Treesitter / Parser Tooling",
		type = "Parser tooling",
		languages = "Treesitter grammars",
		used = "Indirect",
	},
}
local mason_section_order = {
	"LSP Servers",
	"Formatters",
	"Linters",
	"Debugger / DAP",
	"AI",
	"Treesitter / Parser Tooling",
}

local function render_mason_markdown(packages)
	local grouped = {}

	for _, section in ipairs(mason_section_order) do
		grouped[section] = {}
	end

	for _, package in ipairs(packages) do
		local meta = mason_catalog[package]
		local section = meta and meta.category or "Uncategorized"

		grouped[section] = grouped[section] or {}
		table.insert(grouped[section], {
			name = package,
			type = meta and meta.type or "Unknown",
			languages = meta and meta.languages or "Unknown",
			used = meta and meta.used or "Unknown",
		})
	end

	local lines = {
		"# Mason Packages",
		"",
		"This is the local Mason tool inventory for this Neovim config.",
	}

	for _, section in ipairs(mason_section_order) do
		local entries = grouped[section]
		if entries and #entries > 0 then
			table.insert(lines, "")
			table.insert(lines, "## " .. section)
			table.insert(lines, "")
			table.insert(lines, "| Package | Type | Languages | Used In Config |")
			table.insert(lines, "| --- | --- | --- | --- |")

			table.sort(entries, function(a, b)
				return a.name < b.name
			end)

			for _, entry in ipairs(entries) do
				table.insert(
					lines,
					string.format("| `%s` | %s | %s | %s |", entry.name, entry.type, entry.languages, entry.used)
				)
			end
		end
	end

	local uncategorized = grouped.Uncategorized
	if uncategorized and #uncategorized > 0 then
		table.insert(lines, "")
		table.insert(lines, "## Uncategorized")
		table.insert(lines, "")
		table.insert(lines, "| Package | Type | Languages | Used In Config |")
		table.insert(lines, "| --- | --- | --- | --- |")

		table.sort(uncategorized, function(a, b)
			return a.name < b.name
		end)

		for _, entry in ipairs(uncategorized) do
			table.insert(
				lines,
				string.format("| `%s` | %s | %s | %s |", entry.name, entry.type, entry.languages, entry.used)
			)
		end
	end

	return table.concat(lines, "\n") .. "\n"
end

local function addPlugin(name, cmd)
	local splitcmd = cmd
	local msgcmd = cmd

	if type(cmd) == "string" then
		local split = {}

		for s in string.gmatch(cmd, "%S+") do
			table.insert(split, s)
		end

		splitcmd = split
		msgcmd = split[1]
	else
		msgcmd = cmd[1]
	end

	plugins[name] = {
		cmd = splitcmd,
		msg = "Build via " .. msgcmd,
	}
end

addPlugin("blink.cmp", "cargo build --release")
addPlugin("luasnip", "make install_jsregexp")
addPlugin("nvim-treesitter", "vim TSUpdate")

api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		---@param ev { data: { spec: { name: string, path: string }, kind: string, active: boolean } }
		local name = ev.data.spec.name
		local is_build_event = ev.data.kind == "install" or ev.data.kind == "update"
		local path = ev.data.spec.path
		local build = plugins[name]

		if build and is_build_event then
			vim.notify(name .. ": " .. build.msg .. "...", vim.log.levels.INFO)

			if build.cmd[1] == "vim" then
				vim.schedule(function()
					vim.notify(name .. ": running cmd", vim.log.levels.INFO)
					vim.cmd(build.cmd[2])
				end)
			else
				vim.system(build.cmd, { cwd = path }, function(obj)
					vim.schedule(function()
						if obj.code == 0 then
							vim.notify(name .. ": Build successful!", vim.log.levels.INFO)
						else
							vim.notify(name .. ": Build failed!", vim.log.levels.ERROR)
						end
					end)
				end)
			end
		end
	end,
})

-- Mason trigger
api.nvim_create_autocmd("User", {
	pattern = { "MasonPackageInstalled", "MasonPackageUninstalled" },
	callback = function()
		local packages = require("mason-registry").get_installed_package_names()
		table.sort(packages)

		local path = vim.fn.stdpath("config") .. "/mason_list.md"
		local file = io.open(path, "w")

		if file then
			file:write(render_mason_markdown(packages))
			file:close()
			vim.notify("Mason package list updated in markdown!", vim.log.levels.INFO)
		end
	end,
})

-- blink copilot
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpMenuOpen",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = true
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpMenuClose",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = false
-- 	end,
-- })
