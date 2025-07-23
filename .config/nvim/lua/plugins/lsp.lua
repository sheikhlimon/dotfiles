return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"folke/lazydev.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.lsp.config("*", { capabilities = vim.lsp.protocol.make_client_capabilities() })
		require("mason").setup()
		require("mason-lspconfig").setup({ ---@diagnostic disable-line
			ensure_installed = {
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
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- formatter & linter binaries (NOT lspconfig names)
				"prettier",
				"biome",
				"stylua",
				"isort",
				"black",
				"clang-format",
				"pylint",
				"eslint_d",
			},
			run_on_start = true,
		})
		require("lazydev").setup({ ---@diagnostic disable-line
			library = {
				"nvim-dap-ui",
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end,
}
