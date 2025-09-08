vim.g.mapleader = " "

-- VSCode detection
if vim.g.vscode then
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  vim.opt.ignorecase = true -- case insensitive on search
  vim.opt.smartcase = true -- unless there's a capital

  map({ "n", "x" }, "j", function()
    if vim.v.count == 0 then
      return "gj" -- wrapped movement
    else
      return "j" -- real line movement with count
    end
  end, { expr = true, remap = true, silent = true })

  map({ "n", "x" }, "k", function()
    if vim.v.count == 0 then
      return "gk"
    else
      return "k"
    end
  end, { expr = true, remap = true, silent = true })

  map("n", "<leader>b", "<cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>", opts)
  map("n", "<leader>x", "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", opts)
  map("n", "<leader>ff", "<cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", opts)
  map("n", "<leader>e", "<cmd>call VSCodeNotify('workbench.view.explorer')<CR>", opts)
  map("n", "<leader>fm", "<cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", opts)
  map("n", "<leader>ca", "<cmd>call VSCodeNotify('editor.action.quickFix')<CR>", opts)
  map("n", "gd", "<cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", opts)
  map("n", "gr", "<cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", opts)
  map("n", "<leader>rn", "<cmd>call VSCodeNotify('editor.action.rename')<CR>", opts)
  map("n", "dae", ":%d<CR>", { silent = true, desc = "Delete entire buffer" })

  map("n", "zc", function()
    vim.fn.VSCodeNotify "editor.fold"
  end, opts)

  map("n", "zo", function()
    vim.fn.VSCodeNotify "editor.unfold"
  end, opts)

  map("n", "zM", function()
    vim.fn.VSCodeNotify "editor.foldAll"
  end, opts)

  map("n", "zR", function()
    vim.fn.VSCodeNotify "editor.unfoldAll"
  end, opts)

  -- Copy entire file to system clipboard
  map("n", "<C-a>", [[:%y+<CR>]], opts)

  map("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
  map("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

  -- Optional: some keymaps just for VSCode
  map("n", "U", "<C-r>", { desc = "redo" })
  map("n", "<Esc>", ":nohl<CR>", { desc = "clear search highlights" })
  -- Visual mode: yank selection to system clipboard
  map("v", "<C-c>", '"+y', { remap = true, silent = true, desc = "Copy to system clipboard" })
  map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

  return
end

require "core.options"
require "core.mappings"
require "core.lazy"
require "core.autocmds"
