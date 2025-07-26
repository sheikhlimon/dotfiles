return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "/usr/share/awesome/lib/", words = { "awesome" } },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.cmp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Setup diagnostics
    vim.diagnostic.config {
      underline = false,
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
    }

    -- This function gets run when an LSP attaches to a particular buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        -- Helper function for easier keymap creation
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- LSP Keymaps
        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gT", vim.lsp.buf.type_definition, "Type [D]efinition")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        -- Diagnostic keymaps
        map("<leader>q", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

        -- Document highlighting - highlights references of word under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints toggle (if supported)
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oogle Inlay [H]ints")
        end
      end,
    })

    -- Mason setup
    require("mason").setup {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    -- Get capabilities from blink.cmp instead of nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

    -- Server configurations
    local servers = {
      lua_ls = {},
      vtsls = {
        server_capabilities = {
          documentFormattingProvider = false,
        },
      },
      html = {},
      cssls = {},
      tailwindcss = {},
      graphql = {},
      emmet_ls = {},
      prismals = {},
      yamlls = {},
      pyright = {},
      clangd = {},
    }

    -- Mason-lspconfig setup with handlers
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    }

    -- Mason tool installer
    require("mason-tool-installer").setup {
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
    }
  end,
}

-- might need later
--       tsserver = {
--         settings = {
--           typescript = {
--             inlayHints = {
--               includeInlayParameterNameHints = "all",
--               includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--               includeInlayFunctionParameterTypeHints = true,
--               includeInlayVariableTypeHints = true,
--               includeInlayPropertyDeclarationTypeHints = true,
--               includeInlayFunctionLikeReturnTypeHints = true,
--               includeInlayEnumMemberValueHints = true,
--             },
--           },
--           javascript = {
--             inlayHints = {
--               includeInlayParameterNameHints = "all",
--               includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--               includeInlayFunctionParameterTypeHints = true,
--               includeInlayVariableTypeHints = true,
--               includeInlayPropertyDeclarationTypeHints = true,
--               includeInlayFunctionLikeReturnTypeHints = true,
--               includeInlayEnumMemberValueHints = true,
--             },
--           },
--         },
--       },
--
--       pyright = {
--         settings = {
--           python = {
--             analysis = {
--               autoSearchPaths = true,
--               diagnosticMode = "workspace",
--               useLibraryCodeForTypes = true,
--             },
--           },
--         },
--       },
--     }
