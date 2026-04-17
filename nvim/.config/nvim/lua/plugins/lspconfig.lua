return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
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
  config = function()
    vim.lsp.log.set_level(vim.log.levels.WARN)

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

    -- Set capabilities for all servers via wildcard config
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
    vim.lsp.config("*", { capabilities = capabilities })

    -- Keymaps and inlay hints via LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local function map(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        if
          client.server_capabilities.inlayHintProvider
          and vim.lsp.inlay_hint
          and type(vim.lsp.inlay_hint.enable) == "function"
        then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })
  end,
}
