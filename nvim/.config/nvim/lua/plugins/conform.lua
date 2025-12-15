return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier", "biome" },
        typescript = { "prettier", "biome" },
        typescriptreact = { "prettier", "biome" },
        javascriptreact = { "prettier", "biome" },
        svelte = { "prettier", "biome" },
        css = { "prettier", "biome" },
        html = { "prettier" },
        json = { "prettier", "biome" },
        yaml = { "prettier" },
        markdown = { "prettier", "biome" },
        graphql = { "prettier" },
        python = { "isort", "black" },
        bash = { "shfmt" },
        go = { "goimports" },
      },
      formatters = {
        biome = {
          condition = function(self, ctx)
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
      -- format_on_save = {
      --   timeout_ms = 1000,
      --   lsp_format = "fallback",
      -- },
    }

    -- Save and format manually
    vim.keymap.set("n", "<C-s>", function()
      require("conform").format { async = false } -- format first
      vim.cmd "w" -- then save
    end, { desc = "Format buffer and save", noremap = true, silent = true })

    -- Manual format keymap: <leader>fm
    vim.keymap.set("n", "<leader>fm", function()
      conform.format { async = true }
    end, { desc = "Format buffer", noremap = true, silent = true })
  end,
}
