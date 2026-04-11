-- insert capabilities
local capabilities = require("lsp.capabilities").getCapabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
})

-- default lsp server
local lsps = { "html", "cssls" }
vim.lsp.enable(lsps)

-- lua ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
				},

				-- library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			hint = {
				enable = true,
			},
		},
	},
})
vim.lsp.enable("lua_ls")

-- Clangd
vim.lsp.config("clangd", {
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})
vim.lsp.enable("clangd")

-- tsgo
vim.lsp.config("tsgo", {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
		"tsconfig.base.json",
	},
})
vim.lsp.enable("tsgo")

-- Tailwindcss
vim.lsp.config("tailwindcss", {
	-- cmd = {
	-- 	"node",
	-- 	"/home/vee/qtest/tailwindcss-intellisense/packages/tailwindcss-language-server/bin/tailwindcss-language-server",
	-- 	"--stdio",
	-- 	"--oxide=/home/vee/qtest/tailwindcss-intellisense/packages/tailwindcss-language-server/bin/oxide-helper.js",
	-- },
	filetypes = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"php",
		"twig",
	},
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"postcss.config.js",
		"postcss.config.cjs",
		".git",
	},
	settings = {
		tailwindCSS = {
			includeLanguages = {
				javascript = "html",
				javascriptreact = "html",
				typescript = "html",
				typescriptreact = "html",
			},
			-- experimental = {
			-- 	-- configFile = "./tailwind.config.js",  -- use project config if available
			-- 	configFile = vim.fn.expand("~/qtest/js/tailtest.css"), -- ⬅️ explicitly tell LSP where your config is
			-- 	-- classRegex = {
			-- 	-- 	"tw`([^`]*)`",                     -- tw`text-red-500`
			-- 	-- 	"tw\\(([^)]*)\\)",                 -- tw("text-red-500")
			-- 	-- 	"tw\\.[a-zA-Z]+`([^`]*)`",         -- tw.something`text-red-500`
			-- 	-- 	"clsx\\(([^)]*)\\)",               -- clsx("text-red-500")
			-- 	-- },
			-- },
		},
	},
})
vim.lsp.enable("tailwindcss")

-- Pyright
vim.lsp.config("pyright", {
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
})
vim.lsp.enable("pyright")

-- Dockerfile
vim.lsp.config("dockerls", {
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml", ".git" },
})
vim.lsp.enable("dockerls")

-- Docker Compose
vim.lsp.config("docker_compose_language_service", {
	filetypes = { "yaml.docker-compose" },
	root_markers = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml", ".git" },
})
vim.lsp.enable("docker_compose_language_service")

-- Nginx
vim.lsp.config("nginx_language_server", {
	filetypes = { "nginx" },
	root_markers = { "nginx.conf", ".git" },
})
vim.lsp.enable("nginx_language_server")

vim.notify("3_LSP loaded", vim.log.levels.INFO)
