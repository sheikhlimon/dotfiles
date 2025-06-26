-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = {
  "vtsls",
  "html",
  "cssls",
  "tailwindcss",
  "svelte",
  "lua_ls",
  "graphql",
  "emmet_ls",
  "prismals",
  "pyright",
  "clangd",
  "prettier",
  "biome",
  "stylua",
  "isort",
  "black",
  "clang-format",
  "pylint",
  "eslint_d",
}
vim.lsp.enable(servers)
