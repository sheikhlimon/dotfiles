return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "plenary.nvim",
    "nui.nvim",
    "nvim-web-devicons",
  },
  cmd = "Leet",
  opts = function()
    local imports = require "leetcode.config.imports"

    return {
      lang = "python3",
      debug = true,

      storage = {
        home = "~/projects/leetcode",
      },

      cn = {
        enabled = false,
      },

      -- plugins = {
      --   non_standalone = true,
      -- },
      -- picker = {
      --   provider = "telescope",
      -- },

      injector = {
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
        },
        ["java"] = {
          before = true,
        },
        ["python3"] = {
          before = vim.list_extend({ "from .leetcode import *" }, imports.python3),
          after = { "def test():", "	 test()" },
        },
        ["python"] = {
          before = true,
        },
      },

      cache = {
        update_interval = 60 * 60 * 24,
      },

      -- hooks = {
      --   ["enter"] = function()
      --     pcall(vim.cmd, [[silent! Copilot disable]])
      --   end,
      -- },

      theme = {},

      keys = {
        toggle = { "q", "<Esc>" },
      },

      console = {
        open_on_runcode = true,
      },

      image_support = false,
    }
  end,
  keys = {
    { "<leader>lq", "<cmd>Leet tabs<cr>", mode = "n" },
    { "<leader>lm", "<cmd>Leet menu<cr>", mode = "n" },
    { "<leader>lc", "<cmd>Leet console<cr>", mode = "n" },
    { "<leader>lh", "<cmd>Leet info<cr>", mode = "n" },
    { "<leader>ll", "<cmd>Leet lang<cr>", mode = "n" },
    { "<leader>ld", "<cmd>Leet desc<cr>", mode = "n" },
    { "<leader>lr", "<cmd>Leet run<cr>", mode = "n" },
    { "<leader>ls", "<cmd>Leet submit<cr>", mode = "n" },
    { "<leader>ly", "<cmd>Leet yank<cr>", mode = "n" },
    { "<leader>lo", "<cmd>Leet open<cr>", mode = "n" },
  },
}
