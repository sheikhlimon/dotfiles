local M = {}

local override = require "custom.override"

M.plugins = {
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig"
      },
   },

   override = {
      ["kyazdani42/nvim-tree.lua"] = override.nvimtree,
      ["nvim-treesitter/nvim-treesitter"] = override.treesitter,
      ["lukas-reineke/indent-blankline.nvim"] = override.blankline,
   },

   user = require "custom.plugins",
}

M.ui = {
   theme = "onedark",
}

M.mappings = require "custom.mappings"

return M
