return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false, -- snacks.nvim to be set-up early
  ---@type snacks.Config
  opts = {
    bigfile = { size = 1024 * 1024 },
    scroll = { enabled = true },
    statuscolumn = { enabled = false }, -- disabled until needed
    dashboard = { enabled = false },
    quickfile = { enable = true },
    words = { enabled = false },
    lazygit = {
      configure = false,
      win = { position = "float", width = 0.99, height = 0.99 },
    },
    notifier = { enabled = true, timeout = 3000 },
    notify = {
      enabled = true,
      view = "mini",
      timeout = 3000,
    },
    image = { enabled = false }, -- disable heavy image processing at startup
    indent = {
      indent = { enabled = false },
      animate = { duration = { step = 30, total = 200 } },
      chunk = {
        enabled = true,
        char = { corner_top = "╭", corner_bottom = "╰", arrow = ">" },
      },
    },
    input = {
      icon = "::",
      win = { width = 30, relative = "cursor", row = -3, col = 0 },
    },
    picker = {
      prompt = "   ",
      layout = { preset = "default" },
      sources = {
        files = {
          exclude = { ".node_modules*", ".DS_Store" },
          include = { ".git*", ".go*", ".config", ".local", ".cache" },
        },
        todo_comments = { exclude = { "*.ics" }, include = {} },
      },
    },
  },
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Find Jumps",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects { cwd = vim.fn.expand "~/project/.." }
      end,
      desc = "Find Projects",
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
      "<leader>fn",
      function()
        Snacks.picker.notifications {
          confirm = function(i)
            Snacks.win { ft = "text", text = i.preview and i.preview.text or "", border = "rounded" }
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
      "<leader>fD",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
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
      desc = "Goto Type Definition",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP Workspace Symbols",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
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
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff (Hunks)",
    },
    {
      "<leader>to",
      function()
        Snacks.picker "todo_comments"
      end,
      desc = "Find Todo comments",
    },
    {
      "<leader>u",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
  },
}
