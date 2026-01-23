-- Lua indentation settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    local opt = vim.opt_local
    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.expandtab = true
    -- Optionally add these if you want to be explicit:
    -- opt.autoindent = true
    -- opt.smartindent = true
  end,
  desc = "Set 2-space indentation for Lua files",
})

-- Spell checking for text-based files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  callback = function()
    local opt = vim.opt_local
    opt.spell = true
    opt.spelllang = "en"
  end,
  desc = "Enable spell checking for text files",
})

-- Disable comment continuation on newlines
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
  desc = "Don't continue comments on newlines",
})

-- Auto-open Yazi if no file argument is given
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     -- argc() returns the number of files passed to vim
--     if vim.fn.argc() == 0 then
--       -- Open Yazi in the current working directory
--       vim.cmd "Yazi cwd"
--     end
--   end,
-- })
