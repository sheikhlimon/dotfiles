local M = {}

M.general = {
   i = {
      ["jj"] = {"<esc>", "remapped normal mode jj"}
   }
}

M.treesitter = {
   n = {
      ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "  find media" },
   },
}

return M
