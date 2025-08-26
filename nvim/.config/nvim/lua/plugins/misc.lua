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
  -- {
  --   "norcalli/nvim-colorizer.lua",
  --   config = function()
  --     require("colorizer").setup {
  --       "*",
  --       css = { rgb_fn = true },
  --     }
  --   end,
  -- },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- enable Treesitter-aware pairing
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
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
    opts = {},
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
      vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)
      vim.keymap.set(
        "v",
        "<C-_>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        opts
      )
      vim.keymap.set(
        "v",
        "<C-/>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        opts
      )
    end,
  },
}
