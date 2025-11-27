-- Load all LSP server configurations
-- To add a new LSP server:
-- 1. Add it to mason_servers in /lua/plugins/mason.lua
-- 2. Create server config file here (e.g., json.lua)
-- 3. Add it to this return statement
return {
  vtsls = require "lsp.typescript",
  html = require "lsp.html",
  cssls = require "lsp.css",
  tailwindcss = require "lsp.tailwind",
  pyright = require "lsp.python",
  lua_ls = require "lsp.lua",
  yamlls = require "lsp.yaml",
  clangd = require "lsp.c",
  gopls = require "lsp.go",
  rust_analyzer = require "lsp.rust",
  jsonls = require "lsp.json",
  bashls = require "lsp.bash",
}
