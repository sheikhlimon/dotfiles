-- UI
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cmdheight = 0
vim.opt.scrolloff = 5
vim.opt.title = true
vim.opt.cursorline = true

-- tabs & indentation
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.inccommand = "split"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 200

vim.opt.swapfile = false

vim.opt.fillchars = { eob = " " }
vim.opt.path:append { "**" }
vim.opt.wildignore:append { "*/node_modules/*" }
vim.opt.splitkeep = "cursor"
