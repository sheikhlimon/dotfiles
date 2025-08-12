vim.g.mapleader = " "

-- VSCode detection
if vim.g.vscode then
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  vim.opt.ignorecase = true -- case insensitive on search..
  vim.opt.smartcase = true -- ..unless there's a capital

  local function better_jk(key)
    return function()
      local count = vim.v.count
      if count == 0 then
        if key == "j" then
          return "gj"
        else
          return "gk"
        end
      else
        return key
      end
    end
  end

  map("n", "j", better_jk "j", { expr = true, silent = true })
  map("n", "k", better_jk "k", { expr = true, silent = true })

  map("n", "<leader>b", "<cmd>call VSCodeNotify('workbench.action.files.newUntitledFile')<CR>", opts)
  map("n", "<leader>x", "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", opts)
  map("n", "<leader>ff", "<cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", opts)
  map("n", "<leader>e", "<cmd>call VSCodeNotify('workbench.view.explorer')<CR>", opts)
  map("n", "<leader>fm", "<cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", opts)
  map("n", "<leader>ca", "<cmd>call VSCodeNotify('editor.action.quickFix')<CR>", opts)
  map("n", "gd", "<cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", opts)
  map("n", "gr", "<cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", opts)
  map("n", "<leader>rn", "<cmd>call VSCodeNotify('editor.action.rename')<CR>", opts)

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
  map("v", "<C-c>", '"+y', { desc = "Yank to system clipboard" })
  map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

  return
end

require "core.options"
require "core.mappings"
require "core.lazy"
require "core.autocmds"
