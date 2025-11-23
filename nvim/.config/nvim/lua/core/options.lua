-- UI
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cmdheight = 0
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.title = true
vim.opt.cursorline = true

-- tabs & indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"

vim.opt.fixendofline = true

vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 200 -- time to wait for a mapped sequence to complete (in milliseconds)

vim.opt.wrap = true -- Wrap lines
vim.opt.swapfile = false --swap
vim.opt.undofile = true --keep undo changes

-- search settings
vim.opt.ignorecase = true -- case insensitive on search..
vim.opt.smartcase = true -- ..unless there's a capital
vim.opt.backspace = "indent,eol,start"

-- hide ~ on empty line
vim.opt.fillchars = { eob = " " }
vim.opt.path:append { "**" }
vim.opt.wildignore:append { "*/node_modules/*" }
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
