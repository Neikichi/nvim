-- =========================================================
-- Java LSP (jdtls) - Vanilla 0.12 Setup
-- =========================================================

local jdtls = require("jdtls")

-- ---------------------------------------------------------
-- Project & Workspace (Required for JDTLS stability)
-- ---------------------------------------------------------
local bufname = vim.api.nvim_buf_get_name(0)
local root_marker =
	vim.fs.find({ ".git", "pom.xml", "build.gradle", "mvnw", "gradlew" }, { upward = true, path = bufname })[1]
local root_dir = root_marker and vim.fs.dirname(root_marker) or vim.fn.getcwd()

-- Separate workspace folder per project to avoid cache corruption
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root_dir, ":t")

-- ---------------------------------------------------------
-- Path Setup (Standard Mason locations)
-- ---------------------------------------------------------
local mason_path = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason_path .. "/packages/jdtls"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local java_cmd = vim.env.JAVA_HOME .. "/bin/java"

-- ---------------------------------------------------------
-- Start Configuration
-- ---------------------------------------------------------
local config = {
	cmd = {
		java_cmd,
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		launcher_jar,
		"-configuration",
		jdtls_path .. "/config_linux",
		"-data",
		workspace_dir,
	},

	root_dir = root_dir,

	capabilities = require("blink.cmp").get_lsp_capabilities(),

	on_attach = function(client, bufnr)
		-- Enable semantic tokens for that sweet Java highlighting
		if client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
		end

		-- Java-specific Keymaps (Organize Imports, Extract Variable)
		local opts = { buffer = bufnr, desc = "Java: Organize Imports" }
		vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
		vim.keymap.set("n", "<leader>rv", jdtls.extract_variable, { buffer = bufnr, desc = "Java: Extract Variable" })
	end,

	settings = {
		java = {
			eclipse = { downloadSources = true },
			configuration = {
				runtimes = {
					{
						name = "JavaSE-21",
						path = vim.env.JAVA_HOME,
					},
				},
			},
		},
	},
}

-- Finally, start/attach
jdtls.start_or_attach(config)
