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
            arrow_closed = "▶",
            arrow_open = "▼",
            default = "",
            open = "",
          },
          git = {
            unstaged = "󰅖",
            staged = "✓",
            untracked = "★",
            renamed = "➜",
            deleted = "",
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

    -- Custom highlights
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- File/folder highlights
        vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#565f89" })
        vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = "#7aa2f7" })

        -- Git highlights
        vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = "#f7768e" })
        vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = "#9ece6a" })
        vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = "#bb9af7" })
        vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = "#f7768e" })

        -- Special files
        vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = "#ff9e64", underline = true })
        vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = "#9ece6a" })

        -- Root folder
        vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#7aa2f7", bold = true })
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
