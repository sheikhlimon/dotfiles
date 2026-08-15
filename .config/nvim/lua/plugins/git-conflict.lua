return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gcq", "<cmd>GitConflictListQf<CR>", desc = "Conflict List (Quickfix)" },
    { "<leader>gcr", "<cmd>GitConflictRefresh<CR>", desc = "Conflict Refresh" },
  },
  opts = {
    default_mappings = {
      ours = "co",
      theirs = "ct",
      none = "c0",
      both = "cb",
      next = "]x",
      prev = "[x",
    },
    default_commands = true,
    disable_diagnostics = true,
    list_opener = "copen",
    highlights = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
}
