return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "snacks" } },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    "saghen/blink.cmp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Performance optimizations
    vim.lsp.set_log_level "WARN"

    -- Diagnostics setup
    vim.diagnostic.config {
      virtual_text = false,
      update_in_insert = false,
      underline = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪",
          [vim.diagnostic.severity.INFO] = "󰋽",
          [vim.diagnostic.severity.HINT] = "󰌶",
        },
      },
    }

    -- on_attach function
    local function on_attach(client, bufnr)
      local function map(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      if
        client.server_capabilities.inlayHintProvider
        and vim.lsp.inlay_hint
        and type(vim.lsp.inlay_hint.enable) == "function"
      then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    -- Setup capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
    capabilities.textDocument.diagnostic = nil
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    capabilities.textDocument.semanticTokens = {
      multilineTokenSupport = true,
      dynamicRegistration = false,
    }

    -- Setup servers using new vim.lsp.config API
    local servers = require "lsp"
    local server_names = {}

    for server_name, user_config in pairs(servers) do
      local opts = {
        capabilities = vim.tbl_deep_extend("force", {}, capabilities, user_config.capabilities or {}),
        on_attach = on_attach,
        settings = user_config.settings,
        init_options = user_config.init_options,
        filetypes = user_config.filetypes,
      }

      vim.lsp.config(server_name, opts)
      table.insert(server_names, server_name)
    end

    -- Enable all configured servers
    vim.lsp.enable(server_names)
  end,
}
