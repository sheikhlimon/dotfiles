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
    -- Setup diagnostics
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪",
          [vim.diagnostic.severity.INFO] = "󰋽",
          [vim.diagnostic.severity.HINT] = "󰌶",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
      },
    })

    -- Setup mason
    require("mason").setup()

    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- ✅ Configure lua_ls FIRST, before mason-lspconfig
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

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
      automatic_installation = false,
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

    -- Configure all other LSP servers (lua_ls already configured above)
    local servers = {
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
    }

    for _, server in pairs(servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
      })
    end
  end,
}
