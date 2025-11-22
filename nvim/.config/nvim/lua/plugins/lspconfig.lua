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
  event = "LazyFile", -- Only start LSP when files are actually opened, not on every event
  config = function()
    -- Performance optimizations for large projects
    vim.lsp.set_log_level("WARN") -- Reduce log verbosity

    -- Disable some features for large files
    local function disable_lsp_for_large_file(bufnr)
      local max_filesize = 100 * 1024 -- 100KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      return false
    end

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

    -- Setup capabilities merging blink.cmp with performance optimizations
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
    capabilities.textDocument.diagnostic = nil
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    -- Enable semantic tokens for better performance
    capabilities.textDocument.semanticTokens = {
      multilineTokenSupport = true,
      dynamicRegistration = false,
    }

    -- Load server configurations from separate files
    local servers = require("lsp")

    -- Mason setup is now handled in plugins/mason.lua

    -- Mason-lspconfig setup with smart loading
    -- Use the same server list defined in mason.lua for consistency
    local mason_servers = {
      "vtsls", "html", "cssls", "tailwindcss", "pyright",
      "lua_ls", "yamlls", "clangd", "gopls", "rust_analyzer"
    }

    require("mason-lspconfig").setup {
      ensure_installed = mason_servers,
      handlers = {
        function(server_name)
          local opts = servers[server_name] or {}
          opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
          opts.on_attach = on_attach

          -- Apply default performance flags to all servers that don't have them
          if not opts.flags then
            opts.flags = {
              debounce_text_changes = 200,
              allow_incremental_sync = true,
            }
          end

          -- Only start server if the file has appropriate root markers
          local root_pattern = opts.root_dir or require("lspconfig").util.root_pattern(
            ".git",
            "package.json",
            "tsconfig.json",
            "Cargo.toml",
            "pyproject.toml",
            "setup.py",
            "go.mod",
            ".luarc.json"
          )

          opts.root_dir = function(fname)
            return root_pattern(fname)
          end

          require("lspconfig")[server_name].setup(opts)
        end,
      },
    }

    -- Note: Document colors handled by nvim-highlight-colors plugin
  end,
}
