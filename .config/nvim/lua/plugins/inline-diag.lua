return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup()

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        -- Disable virtual text once LSP attaches
        vim.diagnostic.config({ virtual_text = false })
      end,
    })
  end,
}
