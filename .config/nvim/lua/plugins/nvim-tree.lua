return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  priority = 1000,
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,

    view = {
      width = 26,
      side = "left",
      signcolumn = "no",
    },

    renderer = {
      group_empty = false,
      highlight_git = true,
      root_folder_label = false,
      indent_width = 2,
      indent_markers = {
        enable = true,
        icons = { corner = "└", edge = "│", item = "├" },
      },
      icons = {
        webdev_colors = true,
        show = { file = true, folder = true, folder_arrow = true, git = true },
        glyphs = {
          folder = {
            arrow_closed = "▶",
            arrow_open = "▼",
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
      update_root = false,
    },

    filters = {
      custom = { "^.git$", "node_modules" },
    },

    git = { enable = true },
    actions = { open_file = { resize_window = true } },
  },

  config = function(_, opts)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup(opts)

    -- Auto-open and close
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function()
          if vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1) then
            require("nvim-tree.api").tree.open()
          end
        end, 10)
      end,
    })

    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local wins = vim.api.nvim_list_wins()
        local tree_wins = vim.tbl_filter(function(w)
          return vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)):match "NvimTree_"
        end, wins)
        if #wins - #tree_wins == 1 then
          vim.tbl_map(function(w)
            vim.api.nvim_win_close(w, true)
          end, tree_wins)
        end
      end,
    })

    -- Keymaps
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { silent = true })
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { silent = true })
  end,
}
