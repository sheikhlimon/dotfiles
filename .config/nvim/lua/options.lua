require "nvchad.options"

-- add yours here!

local o = vim.o
o.title = true
o.tabstop = 4 -- A TAB character occupies 2 spaces
o.shiftwidth = 4 -- Number of spaces to use for auto-indentation (<<, >>, ==, autoindent)
o.expandtab = true -- Use spaces instead of TABs (highly recommended for consistency)
o.autoindent = true -- Copy indent from previous line
o.smartindent = true -- Smarter auto-indent for C-like languages
o.wrap = true -- Wrap lines
-- o.cursorlineopt ='both' -- to enable cursorline!
