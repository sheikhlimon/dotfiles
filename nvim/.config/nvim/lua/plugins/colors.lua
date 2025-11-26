return {
  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        variant = "moon", -- auto, main, moon, or dawn
        disable_italics = true,
        dim_inactive_windows = false,
        extend_background_behind_borders = false,
        transparent_background = true,
        highlight_groups = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          CursorLine = { bg = "NONE", fg = "NONE" },
          CursorLineNr = { bg = "NONE" },
          NormalFloat = { bg = "#191724" }, -- main variant base
          FloatBorder = { fg = "#908caa", bg = "#191724" }, -- main variant colors
          FloatTitle = { fg = "#c4a7e7", bg = "#191724", bold = true }, -- main variant colors
          FloatFooter = { fg = "#908caa", bg = "#191724" }, -- main variant colors
          BlinkCmpDoc = { bg = "#191724", fg = "#e0def4" }, -- main variant colors
          BlinkCmpDocBorder = { fg = "#908caa" }, -- main variant colors
          BlinkCmpDocCursorLine = { bg = "#1f1d2e", fg = "#e0def4" }, -- main variant surface
          BlinkCmpBorder = { fg = "#908caa" }, -- main variant colors
          BlinkCmpMenu = { bg = "#191724", fg = "#e0def4" }, -- main variant colors
          BlinkCmpMenuBorder = { fg = "#908caa" }, -- main variant colors
          SnacksIndentChunk = { fg = "#9ccfd8", bg = "NONE" }, -- main variant colors
          TermCursor = { bg = "#908caa", reverse = true }, -- main variant colors
          TermCursorNC = { bg = "#908caa" }, -- main variant colors
          -- Git diff highlights for better contrast
          DiffAdd = { bg = "#3a5a3a", fg = "#9ccfd8" }, -- Brighter green background for additions
          DiffChange = { bg = "#3a3a4a", fg = "#ebbcba" }, -- Blue background for changes
          DiffDelete = { bg = "#6a1a1a", fg = "#eb6f92" }, -- Much darker red background for deletions
          DiffText = { bg = "#4a3a4a", fg = "#f6c177" }, -- Yellow background for modified text
          -- Git diff in picker/preview windows
          SnacksPickerGitDiffAdd = { bg = "#3a5a3a", fg = "#9ccfd8" },
          SnacksPickerGitDiffChange = { bg = "#3a3a4a", fg = "#ebbcba" },
          SnacksPickerGitDiffDelete = { bg = "#6a1a1a", fg = "#eb6f92" },
          SnacksPickerGitDiffText = { bg = "#4a3a4a", fg = "#f6c177" },
        },
      }
      vim.cmd.colorscheme "rose-pine"
    end,
  },

  -- Melange
  -- {
  --   "savq/melange-nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "melange"
  --
  --     -- Custom melange colors (from your original config)
  --     local colors = {
  --       bg = "#1F1F28",
  --       fg = "#dcd7ba",
  --       fg_dim = "#727169",
  --       border = "#4A4A5A",
  --       selection = "#403a36",
  --       scrollbar = "#2A2A38",
  --       title = "#c8c093",
  --       footer = "#727169",
  --     }
  --
  --     -- Helper to disable italics for specific groups
  --     local function disable_italic(group)
  --       local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  --       if not ok or not hl or vim.tbl_isempty(hl) then
  --         return
  --       end
  --       local function rgb_to_hex(v)
  --         if type(v) == "number" then
  --           return string.format("#%06x", v)
  --         end
  --         return v
  --       end
  --       local opts = {
  --         fg = hl.fg and rgb_to_hex(hl.fg) or nil,
  --         bg = hl.bg and rgb_to_hex(hl.bg) or nil,
  --         sp = hl.sp and rgb_to_hex(hl.sp) or nil,
  --         bold = hl.bold,
  --         underline = hl.underline,
  --         undercurl = hl.undercurl,
  --         strikethrough = hl.strikethrough,
  --         italic = false,
  --       }
  --       vim.api.nvim_set_hl(0, group, opts)
  --     end
  --
  --     -- Groups to disable italics for
  --     local italic_groups = {
  --       "Comment", "String", "Keyword", "Function", "Type", "Constant", "Identifier",
  --       "@comment", "@string", "@keyword", "@function", "@type", "@constant", "@identifier",
  --       "@field", "@property", "@variable", "@variable.builtin", "@parameter", "@attribute",
  --       "@lsp.typemod.variable.readonly", "@lsp.typemod.variable.defaultLibrary", "@lsp.typemod.variable.global",
  --     }
  --
  --     -- Apply italic disabling
  --     for _, g in ipairs(italic_groups) do
  --       disable_italic(g)
  --     end
  --
  --     -- Apply custom highlights
  --     vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = colors.bg, fg = colors.fg_dim })
  --     vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.border, bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.bg })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "FloatTitle", { fg = colors.title, bold = true })
  --     vim.api.nvim_set_hl(0, "FloatFooter", { fg = colors.footer })
  --     vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.bg, fg = colors.fg })
  --     vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.selection, fg = colors.fg, bold = true })
  --     vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
  --     vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
  --     vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.bg, fg = colors.fg })
  --     vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.bg, fg = colors.fg })
  --     vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "MasonBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "MasonTitle", { fg = colors.title, bold = true })
  --     vim.api.nvim_set_hl(0, "SnacksBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "SnacksTitle", { fg = colors.title, bold = true })
  --     vim.api.nvim_set_hl(0, "SnacksFooter", { fg = colors.footer })
  --
  --     -- Git diff highlights for Melange theme
  --     vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#3a5a3a", fg = "#98bb6c" }) -- Brighter green for additions
  --     vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3a3a4a", fg = "#a09164" }) -- Blue for changes
  --     vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#6a1a1a", fg = "#e46876" }) -- Much darker red for deletions
  --     vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a3a4a", fg = "#c8c093" }) -- Yellow for modified text
  --
  --     -- Git diff in picker/preview windows for Melange
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffAdd", { bg = "#3a5a3a", fg = "#98bb6c" })
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffChange", { bg = "#3a3a4a", fg = "#a09164" })
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffDelete", { bg = "#6a1a1a", fg = "#e46876" })
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffText", { bg = "#4a3a4a", fg = "#c8c093" })
  --   end,
  -- },
}
