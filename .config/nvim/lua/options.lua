require "nvchad.options"

-- add yours here!

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true
opt.title = true
-- tabs & indentation
opt.tabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.wrap = true -- Wrap lines
opt.swapfile = false
-- search settings
opt.ignorecase = true -- case insensitive on search..
opt.smartcase = true -- ..unless there's a capital
opt.cursorline = false
opt.clipboard:append "unnamedplus"
opt.backspace = "indent,eol,start"
-- hide ~ on empty line
opt.fillchars = { eob = " " }
opt.backspace = { "start", "eol", "indent" }
opt.path:append { "**" }
opt.wildignore:append { "*/node_modules/*" }
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
