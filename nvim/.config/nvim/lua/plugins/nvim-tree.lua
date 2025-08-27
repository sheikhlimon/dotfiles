return {
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  event = "VeryLazy", -- VimEnter for auto-open function
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus NvimTree" },
  },
  -- init = function()
  --   vim.api.nvim_create_autocmd("VimEnter", {
  --     callback = function(data)
  --       local no_name = data.file == "" and vim.fn.argc() == 0
  --       local directory = vim.fn.isdirectory(data.file) == 1
  --
  --       if directory then
  --         vim.cmd.cd(data.file)
  --       end
  --
  --       vim.defer_fn(function()
  --         require("nvim-tree.api").tree.open()
  --
  --         if no_name or directory then
  --           -- Focus NvimTree window
  --           local wins = vim.api.nvim_list_wins()
  --           for _, win in ipairs(wins) do
  --             local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
  --             if bufname:match "NvimTree_" then
  --               vim.api.nvim_set_current_win(win)
  --               break
  --             end
  --           end
  --         else
  --           -- Focus the first non-NvimTree window (the editor)
  --           local wins = vim.api.nvim_list_wins()
  --           for _, win in ipairs(wins) do
  --             local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
  --             if not bufname:match "NvimTree_" then
  --               vim.api.nvim_set_current_win(win)
  --               break
  --             end
  --           end
  --         end
  --       end, 10)
  --     end,
  --   })
  -- end,
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    view = {
      width = 26,
      side = "left",
      signcolumn = "no",
      adaptive_size = false,
      preserve_window_proportions = true,
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      root_folder_label = ":t",
      indent_width = 2,
      indent_markers = {
        enable = true,
        inline_arrows = true,
        icons = {
          corner = "└─",
          edge = "│ ",
          item = "├─",
          bottom = "─",
          none = "  ",
        },
      },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = "󰈚",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = "",
          },
          git = {
            unstaged = "M",
            staged = "✓",
            unmerged = "",
            untracked = "U",
            renamed = "R",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    git = {
      enable = true,
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
      },
    },
    filters = {
      custom = { "^.git$", "node_modules" },
    },
  },
  config = function(_, opts)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup(opts)

    -- Auto-close nvim-tree on quit
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match "NvimTree_" then
            vim.api.nvim_win_close(w, true)
          end
        end
      end,
    })

    -- Highlight groups Kanagawa style
    local function setup_highlights()
      local colors = {
        blue = "#7E9CD8",
        orange = "#FFA066",
        red = "#E82424",
        green = "#98BB6C",
        purple = "#957FB8",
        gray = "#565f89",
      }

      vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = "#2a2a2a" })
      vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.blue, bold = true })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.blue, bold = true })
      vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = colors.gray })
      vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = colors.blue })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = colors.blue })
      vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = colors.orange })
      vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = colors.green })
      vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = colors.purple })
      vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = colors.red })
      vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = colors.orange, bold = true })
    end

    vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlights })
    setup_highlights()
  end,
}
