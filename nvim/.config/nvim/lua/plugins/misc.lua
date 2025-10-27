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

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },

  -- Markdown/code companion previews
  -- {
  --   "OXY2DEV/markview.nvim",
  --   ft = { "markdown", "codecompanion" },
  --   opts = { preview = { filetypes = { "md", "markdown", "codecompanion" } } },
  -- },

  -- Comment.nvim
  {
    "numToStr/Comment.nvim",
    opts = {},
    config = function(_, opts)
      require("Comment").setup(opts)
      local keymap_opts = { noremap = true, silent = true }
      -- Normal mode toggles
      vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, keymap_opts)
      vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, keymap_opts)
      -- Visual mode toggles
      vim.keymap.set(
        "v",
        "<C-_>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        keymap_opts
      )
      vim.keymap.set(
        "v",
        "<C-/>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        keymap_opts
      )
    end,
  },

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
