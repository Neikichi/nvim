local api = vim.api

local plugins = {}

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

		local path = vim.fn.stdpath("config") .. "/mason_list.txt"
		local file = io.open(path, "w")

		if file then
			file:write(table.concat(packages, "\n"))
			file:close()
			vim.notify("Mason package list updated!", vim.log.levels.INFO)
		end
	end,
})
