-- overriding default plugin configs!
local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"html",
		"css",
		"javascript",
		"json",
		"markdown",
		"c",
		"bash",
		"lua",
		"cpp",
		"python",
	},
}

M.nvimtree = {
	git = { enable = true, ignore = false },
	renderer = { highlight_git = true, icons = { show = { git = true } } },
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- shell
		"shellcheck",

		-- c/cpp
		"clangd",

		-- python
		"pyright",

		-- java
		-- "jdtls",
	},
}

return M
