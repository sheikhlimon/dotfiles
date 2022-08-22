return {
   -- autoclose tags in html, jsx etc
   ["windwp/nvim-ts-autotag"] = {
      ft = { "html", "javascriptreact" },
      after = "nvim-treesitter",
      config = function()
         require("custom.plugins.smolconfigs").autotag()
      end,
   },

   -- format & linting
   ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require "custom.plugins.null-ls"
      end,
   },

   -- get highlight group under cursor
   ["nvim-treesitter/playground"] = {
      cmd = "TSCaptureUnderCursor",
      config = function()
         require("nvim-treesitter.configs").setup()
      end,
   },

   ["Pocco81/AutoSave.nvim"] = {
      module = "autosave",
      config = function()
         require("custom.plugins.smolconfigs").autosave()
      end,
   },
}
