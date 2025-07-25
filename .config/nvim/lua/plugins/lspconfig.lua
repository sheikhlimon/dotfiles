return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp", -- <- Needed for capabilities
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Setup mason
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"graphql",
				"emmet_ls",
				"prismals",
				"yamlls",
				"pyright",
				"clangd",
			},
			automatic_installation = true,
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"biome",
				"stylua",
				"isort",
				"black",
				"clang-format",
				"pylint",
				"eslint_d",
			},
		})

		local lspconfig = require("lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		-- All others automatically
		for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
			if server ~= "lua_ls" then
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end
		end
	end,
}
