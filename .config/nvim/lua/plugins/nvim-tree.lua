return {
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,
    view = {
      width = {
        min = 26,
        max = 40,
      },
      side = "left",
      adaptive_size = true,
      signcolumn = "no",
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      root_folder_label = ":~",
      indent_width = 2,
      indent_markers = {
        enable = true,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "├",
          bottom = "─",
          none = " ",
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
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
          },
          git = {
            unstaged = "M",
            staged = "✓",
            untracked = "U",
            renamed = "R",
            deleted = "D",
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

    -- Custom highlights for Kanagawa theme
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local colors = {
          blue = "#7E9CD8",
          orange = "#FFA066",
          red = "#E82424",
          green = "#98BB6C",
          purple = "#957FB8",
          gray = "#565f89",
        }

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
        -- vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = colors.gray })
      end,
    })

    -- Apply highlights immediately
    vim.cmd "doautocmd ColorScheme"

    -- Auto-close nvim-tree when quitting nvim
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local tree_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in pairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match "NvimTree_" ~= nil then
            table.insert(tree_wins, w)
          end
        end
        -- Close all nvim-tree windows
        for _, w in pairs(tree_wins) do
          vim.api.nvim_win_close(w, true)
        end
      end,
    })

    -- Keymaps
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { silent = true })
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { silent = true })
  end,
}
