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
          { path = "snacks.nvim", words = { "snacks" } },
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
      virtual_text = true,
      update_in_insert = true,
      underline = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
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
    }

    -- Enable inlay hints by default
    if vim.lsp.inlay_hint then
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-inlay-hints", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end
        end,
      })
    end

    -- This function gets run when an LSP attaches to a particular buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        -- Helper function for easier keymap creation
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Using your map() helper for clarity & descriptions
        -- map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        -- map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gT", vim.lsp.buf.type_definition, "Type [D]efinition")
        map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        -- Diagnostic keymaps
        map("<leader>lq", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

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

    -- Get capabilities from blink.cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

    -- Server configurations
    local servers = {
      lua_ls = {},
      vtsls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            format = { enable = false },
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              -- 	functionLikeReturnTypes = { enabled = true },
              -- 	parameterNames = { enabled = "literals" },
              -- 	parameterTypes = { enabled = true },
              -- 	propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = true },
            },
          },
          javascript = {
            format = { enable = false },
          },
        },
      },
      html = {},
      cssls = {
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      },
      tailwindcss = {
        settings = {
          tailwindCSS = {
            emmetCompletions = true,
            validate = true,
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidScreen = "error",
              invalidVariant = "error",
              invalidConfigPath = "error",
              invalidTailwindDirective = "error",
              recommendedVariantOrder = "warning",
            },
            -- Tailwind class attributes configuration
            classAttributes = { "class", "className", "classList", "ngClass", ":class" },

            -- Experimental regex patterns to detect Tailwind classes in various syntaxes
            experimental = {
              classRegex = {
                -- tw`...` or tw("...")
                "tw`([^`]*)`",
                "tw\\(([^)]*)\\)",

                -- @apply directive inside SCSS / CSS
                "@apply\\s+([^;]*)",

                -- class and className attributes (HTML, JSX, Vue, Blade with :class)
                'class="([^"]*)"',
                'className="([^"]*)"',
                ':class="([^"]*)"',

                -- Laravel @class directive e.g. @class([ ... ])
                "@class\\(([^)]*)\\)",
              },
            },
          },
        },
      },
      graphql = {},
      emmet_ls = {},
      prismals = {},
      yamlls = {},
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
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
        "shfmt",
      },
    }
  end,
}
