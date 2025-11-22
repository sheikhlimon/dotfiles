return {
  "williamboman/mason.nvim",
  cmd = "Mason",
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
        package_installed = "",
        package_pending = "",
        package_uninstalled = "",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- LSP servers that should be automatically installed
    local lsp_servers = {
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
    }

    -- Additional tools (formatters, linters, etc.)
    local tools = {
      "prettier",
      "stylua",
      "black",
      "isort",
      "clang-format",
      "shfmt",
      "eslint_d",
      "pylint",
      "goimports",
      "just-lsp",
    }

    -- Setup mason-lspconfig
    require("mason-lspconfig").setup {
      ensure_installed = lsp_servers,
      automatic_installation = false, -- Don't auto-install, let us control it
    }

    -- Setup mason-tool-installer with performance optimizations
    require("mason-tool-installer").setup {
      ensure_installed = tools,
      auto_update = false, -- Disable auto-update for faster startup
      run_on_start = false, -- Don't run on start, run on demand
      debounce_hours = 24, -- Only check for updates once per day
      start_delay = 3000, -- Delay after Neovim starts (3 seconds)
    }
  end,
}