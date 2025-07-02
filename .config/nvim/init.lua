vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- VSCode detection
if vim.g.vscode then
  -- VSCode-specific config
  local map = vim.keymap.set

  local opts = { noremap = true, silent = true }

  map("n", "<leader>b", "<cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>", opts)
  map("n", "<leader>x", "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", opts)
  map("n", "<leader>ff", "<cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", opts)
  map("n", "<leader>e", "<cmd>call VSCodeNotify('workbench.view.explorer')<CR>", opts)
  map("n", "<leader>fm", "<cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", opts)

  -- Copy entire file to system clipboard
  map("n", "<C-a>", ":%y+<CR>", opts)

  -- Optional: some keymaps just for VSCode
  map("n", "U", "<C-r>") -- Redo
  --save
  map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })

  --copy to system clipboard and paste
  map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
  map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

  return -- Don't load NvChad
end

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
