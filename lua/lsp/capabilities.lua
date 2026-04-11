local M = {}

function M.getCapabilities()
	local base = vim.lsp.protocol.make_client_capabilities()

	if base.workspace then
		base.workspace.didChangeWatchedFiles = nil
	end

	base.general = base.general or {}
	base.general.positionEncodings = { "utf-16" }

	return require("cmp_nvim_lsp").default_capabilities(base)
	-- return require("blink.cmp").get_lsp_capabilities(base)
end

return M
