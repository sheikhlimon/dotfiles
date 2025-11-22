-- Load all LSP server configurations
return {
  vtsls = require("lsp.typescript"),
  html = require("lsp.html"),
  cssls = require("lsp.css"),
  tailwindcss = require("lsp.tailwind"),
  pyright = require("lsp.python"),
  lua_ls = require("lsp.lua"),
  yamlls = require("lsp.yaml"),
  clangd = require("lsp.c"),
  gopls = require("lsp.go"),
  rust_analyzer = require("lsp.rust"),
}