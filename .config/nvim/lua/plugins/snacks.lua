return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    local snacks = require "snacks"
    snacks.setup {
      lazygit = {},
      bigfile = { size = 1024 * 1024 },
      word = { enabled = true },

      scroll = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      blame_line = {
        width = 0.6,
        height = 0.6,
        border = "rounded",
        title = " Git Blame ",
        title_pos = "center",
        ft = "git",
      },
      indent = {
        indent = { enabled = false },
        animate = {
          duration = {
            step = 30,
            total = 200,
          },
        },
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            arrow = ">",
          },
        },
      },
      input = {
        icon = "::",
        win = {
          width = 35,
          relative = "cursor",
          row = -3, -- puts prompt on top of cursor
          col = 0,
        },
      },
      picker = {
        prompt = " :: ",
        sources = {
          explorer = {
            exclude = { ".node_modules*", ".DS_Store" },
            include = { ".*" },
          },
          files = {
            exclude = { ".node_modules*", ".DS_Store" },
            include = { ".git*", ".go*", ".config", ".local", ".cache" },
          },
          todo_comments = {
            exclude = { "*.ics" },
            include = {},
          },
        },
      },
    }

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
    end

    -- === Pickers === --
    map("n", "<leader>fg", snacks.picker.grep, "Live Grep")
    map("n", "<leader>ff", snacks.picker.files, "Find Files")
    map("n", "<leader>fr", snacks.picker.recent, "Recent Files")
    map("n", "<leader>fh", snacks.picker.help, "Help Pages")
    map("n", "<leader>r", snacks.picker.registers, "Registers")
    map("n", "<leader>th", snacks.picker.colorschemes, "Theme Picker")

    -- === Reference Navigation === --
    map({ "n", "t" }, "]]", function()
      snacks.words.jump(vim.v.count1)
    end, "Next Reference")

    map({ "n", "t" }, "[[", function()
      snacks.words.jump(-vim.v.count1)
    end, "Previous Reference")

    -- === Git === --
    map("n", "<leader>n", snacks.picker.notifications, "Notification History")
    map("n", "<leader>fd", snacks.picker.diagnostics, "Buffer Diagnostics")
    map("n", "<leader>gf", snacks.picker.git_diff, "Git Status")
    map("n", "<leader>gg", snacks.lazygit.open, "Lazy Git")

    map("n", "<leader>gl", snacks.picker.git_log, "Git Log")

    map("n", "<leader>gb", function()
      require("snacks.git").blame_line()
    end, "Git Blame Line")

    map("n", "<leader>pp", ":lua Snacks.picker() <cr>", "opens a list of of pickers to choose from")
    map("n", "<leader>to", function()
      snacks.picker "todo_comments"
    end, "Find Todo comments")
  end,
}
