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
    capabilities.textDocument.diagnostic = nil
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
      html = {
        filetypes = {
          "html",
          "blade",
          "javascriptreact",
          "typescriptreact",
          "svelte",
        },
        root_markers = { "index.html", ".git" },
        init_options = { provideFormatter = true },
      },
      cssls = {
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      },
      tailwindcss = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "html",
          "blade",
          "astro",
          "css",
          "scss",
        },
        root_markers = {
          "tailwind.config.js",
          "tailwind.config.cjs",
          "tailwind.config.mjs",
          "tailwind.config.ts",
          "postcss.config.js",
          "postcss.config.ts",
          "package.json",
          ".git",
        },
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
      lua_ls = {
        filetypes = { "lua" },
        root_markers = {
          ".luarc.json",
          ".luarc.jsonc",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "selene.yml",
          ".git",
        },
        settings = {
          Lua = {
            diagnostics = {
              disable = { "missing-fields" },
              globals = {
                "vim",
                "Snacks",
              },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      },
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
      rust_analyzer = {
        root_markers = { "Cargo.lock" },
        filetypes = { "rust" },
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
            diagnostics = {
              enable = true,
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
        "just-lsp",
      },
      auto_update = true,
      run_on_start = true,
    }
  end,
}
