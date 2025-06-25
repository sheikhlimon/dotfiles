require "nvchad.options"

-- add yours here!

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

opt.title = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.wrap = true -- Wrap lines
opt.swapfile = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = false

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- splitting windows
opt.splitright = true
opt.splitbelow = true

opt.clipboard:append "unnamedplus"

opt.backspace = "indent,eol,start"

-- hide ~ on empty line
opt.fillchars = { eob = " " }

-- opt.cursorlineopt ='both' -- to enable cursorline!
