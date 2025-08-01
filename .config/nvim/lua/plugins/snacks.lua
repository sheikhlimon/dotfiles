return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { size = 1024 * 1024 },
    scroll = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
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
        width = 30,
        relative = "cursor",
        row = -3,
        col = 0,
      },
    },
    picker = {
      prompt = " :: ",
      layout = { preset = "default" },
      sources = {
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
  },
  keys = {
    {
      "<leader>ls",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath "config" }
      end,
      desc = "Find Config File",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>r",
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>th",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Theme Picker",
    },
    {
      "<leader>fn",
      function()
        Snacks.picker.notifications {
          win = {
            preview = {
              wo = { number = false, relativenumber = false, signcolumn = "no" },
              bo = { filetype = "text" },
            },
          },

          ---@param picker snacks.Picker
          ---@param item snacks.picker.Item
          confirm = function(picker, item)
            picker:close()
            if item and item.preview then
              Snacks.win {
                ft = "text",
                text = item.preview.text,
                wo = {
                  number = false,
                  relativenumber = false,
                  signcolumn = "no",
                },
                border = "rounded",
                height = 0.6,
                width = 0.7,
                bo = {
                  syntax = "markdown",
                },
                title = "  Notification Preview ",
                title_pos = "center",
              }
            end
          end,
        }
      end,
      desc = "Notification History",
    },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Previous Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Status",
    },
    -- git
    {
      "<leader>gg",
      function()
        Snacks.lazygit.open()
      end,
      desc = "Lazy Git",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>pp",
      function()
        Snacks.picker()
      end,
      desc = "Pick a snacks source",
    },
    {
      "<leader>to",
      function()
        Snacks.picker "todo_comments"
      end,
      desc = "Find Todo comments",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
  },
}
