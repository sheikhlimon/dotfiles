-- Standalone plugins with less than 10 lines of config go here
return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          -- Disable virtual text once LSP attaches
          vim.diagnostic.config { virtual_text = false }
        end,
      })
    end,
  },
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
  {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
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
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      preview = {
        filetypes = { "md", "markdown", "codecompanion" },
      },
    },
  },
  -- Easily comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    opts = {}, -- can include plugin setup options here
    config = function(_, opts)
      -- Setup plugin
      require("Comment").setup(opts)

      -- Keymaps
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
  -- {
  -- "kawre/leetcode.nvim",
  -- dependencies = {
  --   "nvim-lua/plenary.nvim",
  --   "MunifTanjim/nui.nvim",
  -- },
  -- opts = {
  --   lang = "python3",
  --   storage = {
  --     home = "~/projects/leetcode",
  --   },
  --   cache = { update_interval = 60 * 60 * 24 },
  -- },
}
