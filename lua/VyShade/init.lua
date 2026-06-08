local M = {}
local api = vim.api

local state = require("VyShade.state")
state.ns = api.nvim_create_namespace("VyShade")

local defaults = {
	mode = "virtual",
	virt_text = "󱓻 ",
	highlight = { hex = true, lspvars = true },
}

M.setup = function(opts)
	state.config = vim.tbl_deep_extend("force", defaults, opts or {})
	M.run()
end

M.run = function()
	local conf = state.config
	if not conf or vim.tbl_isempty(conf) then
		return
	end

	M.attach = require("VyShade.attach")

	api.nvim_create_autocmd({
		"TextChanged",
		"TextChangedI",
		"TextChangedP",
		"VimResized",
		"LspAttach",
		"WinScrolled",
		"BufEnter",
	}, {
		callback = function(args)
			if vim.bo[args.buf].bl then
				M.attach(args.buf, args.event)
			end
		end,
	})
end

return M
