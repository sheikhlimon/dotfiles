return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Setup Mason
		require("mason").setup()

		-- Define servers to install and configure
		local servers = {
			"vtsls",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_ls",
			"prismals",
			"yamlls",
			"pyright",
			"clangd",
		}

		-- Install LSP servers
		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_installation = true,
		})

		-- Install formatters and linters
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

		-- Setup LSP servers
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		for _, server in ipairs(servers) do
			if server == "lua_ls" then
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim", "require" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				})
			else
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end
		end
	end,
}
