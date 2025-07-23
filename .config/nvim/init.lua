vim.g.mapleader = " "

-- VSCode detection
if vim.g.vscode then
	local map = vim.keymap.set
	local opt = vim.opt
	local opts = { noremap = true, silent = true }

	-- tabs & indentation
	opt.autoindent = true
	opt.incsearch = true
	opt.smartindent = true
	-- search settings
	opt.ignorecase = true -- case insensitive on search..
	opt.smartcase = true -- ..unless there's a capital

	-- Use leader + / for comment
	map("n", "<leader>/", "<cmd>call VSCodeNotify('editor.action.commentLine')<CR>", opts)
	map("v", "<leader>/", "<cmd>call VSCodeNotify('editor.action.commentLine')<CR>", opts)

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
		vim.fn.VSCodeNotify("editor.fold")
	end, opts)

	map("n", "zo", function()
		vim.fn.VSCodeNotify("editor.unfold")
	end, opts)

	map("n", "zM", function()
		vim.fn.VSCodeNotify("editor.foldAll")
	end, opts)

	map("n", "zR", function()
		vim.fn.VSCodeNotify("editor.unfoldAll")
	end, opts)

	-- Copy entire file to system clipboard
	map("n", "<C-a>", [[:%y+<CR>]], opts)

	map("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
	map("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

	--move up and down in wrapped lines
	map("n", "j", "gj", { remap = true, silent = true })
	map("n", "k", "gk", { remap = true, silent = true })

	-- Optional: some keymaps just for VSCode

	map("n", "U", "<C-r>", { desc = "redo" })
	map("n", "<Esc>", ":nohl<CR>", { desc = "clear search highlights" })
	map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })
	-- Visual mode: yank selection to system clipboard
	map("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
	map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

	return
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("autocmds")

vim.schedule(function()
	require("mappings")
end)

require("lazy").setup("plugins")
