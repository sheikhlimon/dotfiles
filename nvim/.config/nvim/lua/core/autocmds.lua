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

-- Treat all .env* files as shell scripts
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".env*",
  callback = function()
    vim.bo.filetype = "sh"
  end,
  desc = "Set filetype to shell for .env files",
})

-- Auto-open Yazi if no file argument is given
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- argc() returns the number of files passed to vim
    if vim.fn.argc() == 0 then
      -- Open Yazi in the current working directory
      vim.cmd "Yazi cwd"
    end
  end,
})
