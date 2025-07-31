local opt = vim.opt

-- UI
opt.relativenumber = true
opt.number = true
opt.cmdheight = 0
opt.termguicolors = true
opt.scrolloff = 8
opt.title = true
opt.cursorline = false

-- tabs & indentation
opt.shiftwidth = 2 -- number of spaces to use for each step of (auto)indent
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true -- use spaces instead of tabs
opt.smartindent = true
opt.autoindent = true

opt.wrap = true -- Wrap lines
opt.swapfile = false --swap
opt.undofile = true --keep undo changes

-- search settings
opt.ignorecase = true -- case insensitive on search..
opt.smartcase = true -- ..unless there's a capital
opt.backspace = "indent,eol,start"

-- hide ~ on empty line
opt.fillchars = { eob = " " }
opt.path:append { "**" }
opt.wildignore:append { "*/node_modules/*" }
opt.splitright = true
opt.splitkeep = "cursor"
