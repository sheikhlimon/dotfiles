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
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.cmp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Diagnostics setup
    vim.diagnostic.config {
      virtual_text = false,
      update_in_insert = true,
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

    -- on_attach function: keymaps + inlay hints
    local function on_attach(client, bufnr)
      local function map(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      -- map("K", vim.lsp.buf.hover, "Hover Documentation")
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- Enable inlay hints if supported and API available
      if
        client.server_capabilities.inlayHintProvider
        and vim.lsp.inlay_hint
        and type(vim.lsp.inlay_hint.enable) == "function"
      then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    -- Setup capabilities merging blink.cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- Servers and their configs
    local servers = {
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
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            format = { enable = false },
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = {
                enabled = true,
                suppressWhenAnnotationIsPresent = true,
              },
              parameterNames = {
                enabled = "literals",
                suppressWhenArgumentMatchesName = true,
              },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            format = { enable = false },
            inlayHints = {
              enumMemberValues = { enabled = true },
              parameterNames = {
                enabled = "literals",
                suppressWhenArgumentMatchesName = true,
              },
            },
          },
        },
      },
      html = { filetypes = { "html", "templ" } },
      cssls = {
        settings = {
          css = { validate = true, lint = { unknownAtRules = "ignore" } },
          scss = { validate = true, lint = { unknownAtRules = "ignore" } },
          less = { validate = true, lint = { unknownAtRules = "ignore" } },
        },
      },
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "tw`([^`]*)`",
                "tw\\(([^)]*)\\)",
                "class[:]?\\s*=\\s*[{]([^}]*)[}]",
                'class[:]?\\s*=\\s*"([^"]*)"',
              },
            },
            classAttributes = { "class", "className", "classList", "ngClass", ":class" },
          },
        },
      },
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      },
      graphql = {},
      emmet_ls = { filetypes = { "html", "css", "javascriptreact", "typescriptreact" } },
      lua_ls = {},
      prismals = {},
      yamlls = { settings = { yaml = { keyOrdering = false } } },
      clangd = { cmd = { "clangd", "--background-index", "--clang-tidy" } },
      gopls = {
        filetypes = { "go", "gomod" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              nilness = true,
              shadow = true,
              unusedwrite = true,
            },
            staticcheck = true,
            codelenses = {
              generate = true,
              gc_details = true,
              tidy = true,
            },
          },
        },
      },
    }

    -- Mason setup
    require("mason").setup {
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    -- Mason-lspconfig setup
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          local opts = servers[server_name] or {}
          opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
          opts.on_attach = on_attach
          require("lspconfig")[server_name].setup(opts)
        end,
      },
    }

    -- Mason-tool-installer setup
    require("mason-tool-installer").setup {
      ensure_installed = {
        "prettier",
        "stylua",
        "black",
        "isort",
        "clang-format",
        "shfmt",
        "eslint_d",
        "pylint",
        "goimports",
      },
      auto_update = true,
      run_on_start = true,
    }
  end,
}
