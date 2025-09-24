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
      -- format_on_save = {
      --   timeout_ms = 1000,
      --   lsp_format = "fallback",
      -- },
    }

    -- Save and format manually
    vim.keymap.set("n", "<C-s>", function()
      vim.cmd "w" -- save first
      require("conform").format { async = true } -- then format
    end, { desc = "Save buffer and format", noremap = true, silent = true })

    -- Manual format keymap: <leader>fm
    vim.keymap.set("n", "<leader>fm", function()
      conform.format { async = true }
    end, { desc = "Format buffer", noremap = true, silent = true })
  end,
}
