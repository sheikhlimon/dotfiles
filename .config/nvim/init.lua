vim.loader.enable()

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

require "config.options"
require "config.mappings"
require "config.lazy"
require "config.autocmds"
require "config.remote_clipboard"
