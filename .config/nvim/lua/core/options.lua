-- UI
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cmdheight = 0
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.title = true
vim.opt.cursorline = false

-- tabs & indentation
vim.opt.shiftwidth = 2 -- number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 2
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.autoindent = true
vim.opt.breakindent = true -- Enable break indent

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
