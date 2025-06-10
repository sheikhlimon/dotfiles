require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Filetype-specific settings for Lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua", -- Apply these settings when the filetype is 'lua'
  callback = function()
    vim.opt_local.tabstop = 2 -- Lua: A TAB character occupies 2 spaces
    vim.opt_local.shiftwidth = 2 -- Lua: Auto-indent to 2 spaces
    vim.opt_local.expandtab = true -- Lua: Use spaces instead of TABs
    -- autoindent and smartindent are typically fine globally, but you could set them here too if needed
    -- vim.opt_local.autoindent = true
    -- vim.opt_local.smartindent = true
  end,
  desc = "Set 2-space indentation for Lua files",
})
