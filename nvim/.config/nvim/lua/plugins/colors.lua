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
          NormalFloat = { bg = "NONE" }, -- completely transparent float
          FloatBorder = { fg = "#908caa", bg = "NONE" }, -- transparent outside, visible inside
          FloatTitle = { fg = "#c4a7e7", bg = "NONE", bold = true }, -- transparent background like melange
          FloatFooter = { fg = "#908caa", bg = "NONE" }, -- no background to avoid artifacts
          BlinkCmpDoc = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          BlinkCmpDocBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          BlinkCmpDocCursorLine = { bg = "#1f1d2e", fg = "#e0def4" }, -- main variant surface
          BlinkCmpMenu = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          BlinkCmpMenuBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          -- Noice floating windows
          NoiceFloat = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          NoiceBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          NoiceCmdlinePopup = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          NoiceCmdlinePopupBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          NoicePopup = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          NoicePopupBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          -- Noice documentation floating windows
          NoiceConfirm = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          NoiceConfirmBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          NoiceMini = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          NoiceMiniBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          NoiceSplit = { bg = "NONE", fg = "#e0def4" }, -- transparent background
          NoiceSplitBorder = { fg = "#908caa", bg = "NONE" }, -- transparent background, visible border
          -- Separator/divider lines
          WinSeparator = { fg = "#908caa", bg = "NONE" }, -- transparent separator
          VertSplit = { fg = "#908caa", bg = "NONE" }, -- transparent vertical split
          -- Documentation separators
          BlinkCmpDocSeparator = { fg = "NONE", bg = "NONE" }, -- transparent doc separator
          NoiceDocSeparator = { fg = "NONE", bg = "NONE" }, -- transparent noice doc separator
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
  --     -- Apply Rose Pine highlight groups to Melange
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  --     vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", fg = "NONE" })
  --     vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" }) -- completely transparent float
  --     vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#908caa", bg = "NONE" }) -- transparent outside, visible inside
  --     vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#c8c093", bg = "NONE", bold = true }) -- Melange cream color
  --     vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#908caa", bg = "NONE" }) -- no background to avoid artifacts
  --     vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { bg = "#1f1d2e", fg = "#e0def4" }) -- main variant surface
  --     vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --
  --     -- Noice floating windows
  --     vim.api.nvim_set_hl(0, "NoiceFloat", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "NoiceBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     vim.api.nvim_set_hl(0, "NoicePopup", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "NoicePopupBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     -- Noice documentation floating windows
  --     vim.api.nvim_set_hl(0, "NoiceConfirm", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     vim.api.nvim_set_hl(0, "NoiceMini", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "NoiceMiniBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     vim.api.nvim_set_hl(0, "NoiceSplit", { bg = "NONE", fg = "#e0def4" }) -- transparent background
  --     vim.api.nvim_set_hl(0, "NoiceSplitBorder", { fg = "#908caa", bg = "NONE" }) -- transparent background, visible border
  --     -- Separator/divider lines
  --     vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#908caa", bg = "NONE" }) -- transparent separator
  --     vim.api.nvim_set_hl(0, "VertSplit", { fg = "#908caa", bg = "NONE" }) -- transparent vertical split
  --     -- Documentation separators
  --     vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { fg = "NONE", bg = "NONE" }) -- transparent doc separator
  --     vim.api.nvim_set_hl(0, "NoiceDocSeparator", { fg = "NONE", bg = "NONE" }) -- transparent noice doc separator
  --     vim.api.nvim_set_hl(0, "SnacksIndentChunk", { fg = "#f6c177", bg = "NONE" }) -- Melange yellow color
  --     vim.api.nvim_set_hl(0, "TermCursor", { bg = "#908caa", reverse = true }) -- main variant colors
  --     vim.api.nvim_set_hl(0, "TermCursorNC", { bg = "#908caa" }) -- main variant colors
  --     -- Git diff highlights for better contrast
  --     vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#3a5a3a", fg = "#9ccfd8" }) -- Brighter green background for additions
  --     vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3a3a4a", fg = "#ebbcba" }) -- Blue background for changes
  --     vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#6a1a1a", fg = "#eb6f92" }) -- Much darker red background for deletions
  --     vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a3a4a", fg = "#f6c177" }) -- Yellow background for modified text
  --     -- Git diff in picker/preview windows
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffAdd", { bg = "#3a5a3a", fg = "#9ccfd8" })
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffChange", { bg = "#3a3a4a", fg = "#ebbcba" })
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffDelete", { bg = "#6a1a1a", fg = "#eb6f92" })
  --     vim.api.nvim_set_hl(0, "SnacksPickerGitDiffText", { bg = "#4a3a4a", fg = "#f6c177" })
  --
  --   end,
  -- },
}
