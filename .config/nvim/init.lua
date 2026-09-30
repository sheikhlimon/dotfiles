vim.loader.enable()

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- Pass JVM arguments natively to Mason's jdtls wrapper (fixes Lombok and limits RAM)
vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar -Xmx1g"

require "config.options"
require "config.mappings"
require "config.lazy"
require "config.autocmds"
require "config.remote_clipboard"
