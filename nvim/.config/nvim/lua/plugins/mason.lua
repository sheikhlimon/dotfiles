return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  event = "VeryLazy", -- Load Mason after startup, not immediately
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  opts = {
    ui = {
      border = "rounded",
      width = 0.8,
      height = 0.8,
      icons = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Additional tools (formatters, linters, etc.)
    local tools = {
      "prettier",
      "stylua",
      "black",
      "isort",
      "clang-format",
      "shfmt",
      "pylint",
      "goimports",
      "just-lsp",
    }

    -- Setup mason-lspconfig to automatically install and configure LSP servers
    local mason_servers = {
      "vtsls",
      "html",
      "cssls",
      "tailwindcss",
      "pyright",
      "lua_ls",
      "yamlls",
      "clangd",
      "gopls",
      "rust_analyzer",
      "jsonls",
    }

    require("mason-lspconfig").setup {
      ensure_installed = mason_servers,
      automatic_installation = true, -- Auto-install servers, manual config gives us control
    }

    -- Note: Let lspconfig handle the server setup manually

    -- Setup mason-tool-installer to auto-install tools on first start
    require("mason-tool-installer").setup {
      ensure_installed = tools,
      auto_update = false, -- Disable auto-update for faster startup
      run_on_start = true, -- Run on start to install missing tools
      start_delay = 1000, -- Small delay after Neovim starts (1 second)
      debounce_hours = 24, -- Only check for updates once per day
    }
  end,
}
