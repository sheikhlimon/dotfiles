return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        typescriptreact = { "prettier", "eslint" },
        javascriptreact = { "prettier", "eslint" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        python = { "isort", "black" },
        bash = { "shfmt" },
        go = { "goimports" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    }

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function()
        conform.format { async = false }
      end,
      desc = "Autoformat buffer with Conform on save",
    })

    -- Manual format keymap: <leader>fm
    vim.keymap.set("n", "<leader>fm", function()
      conform.format { async = true }
    end, { desc = "Format buffer", noremap = true, silent = true })
  end,
}
