-- Standalone plugins with less than 10 lines of config go here
return {
  -- Tiny inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config { virtual_text = false }
    end,
  },

  -- Surround text objects
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "<leader>sa",
        delete = "<leader>sd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- Comment highlighting
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Highlight colors in code
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
      require("nvim-highlight-colors").setup {
        render = "virtual",
        virtual_symbol = "󰻂",
      }
    end,
  },

  -- Markdown/code companion previews
  -- {
  --   "OXY2DEV/markview.nvim",
  --   ft = { "markdown", "codecompanion" },
  --   opts = { preview = { filetypes = { "md", "markdown", "codecompanion" } } },
  -- },

  -- leetcode
  -- {
  --   "kawre/leetcode.nvim",
  --   cmd = "LeetCode", -- lazy-load when you run :LeetCode
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --   },
  --   opts = {
  --     lang = "python3",
  --     storage = { home = "~/projects/leetcode" },
  --     cache = { update_interval = 60 * 60 * 24 }, -- refresh cache every day
  --   },
  -- },
}
