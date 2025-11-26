-- Theme selection - change this value to switch themes
-- Options: "melange", "rose-pine"
local selected_theme = "rose-pine"

return {
  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    enabled = selected_theme == "rose-pine",
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
          -- Git diff highlights using official Rose Pine colors
          DiffAdd = { bg = "#284738", fg = "#9ccfd8" }, -- Subtle green background, foam foreground
          DiffChange = { bg = "#393552", fg = "#ebbcba" }, -- Overlay background, rose foreground
          DiffDelete = { bg = "#3a2d3a", fg = "#eb6f92" }, -- Subtle red background, love foreground
          DiffText = { bg = "#403d52", fg = "#f6c177" }, -- Highlight med background, gold foreground
          -- Git diff in picker/preview windows
          SnacksPickerGitDiffAdd = { bg = "#284738", fg = "#9ccfd8" },
          SnacksPickerGitDiffChange = { bg = "#393552", fg = "#ebbcba" },
          SnacksPickerGitDiffDelete = { bg = "#3a2d3a", fg = "#eb6f92" },
          SnacksPickerGitDiffText = { bg = "#403d52", fg = "#f6c177" },
        },
      }
      vim.cmd.colorscheme "rose-pine"
    end,
  },

  -- Melange
  {
    "savq/melange-nvim",
    lazy = false,
    priority = 1000,
    enabled = selected_theme == "melange",
    config = function()
      vim.cmd.colorscheme "melange"

      -- Helper to disable italics for specific groups
      local function disable_italic(group)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if not ok or not hl or vim.tbl_isempty(hl) then
          return
        end
        local function rgb_to_hex(v)
          if type(v) == "number" then
            return string.format("#%06x", v)
          end
          return v
        end
        local opts = {
          fg = hl.fg and rgb_to_hex(hl.fg) or nil,
          bg = hl.bg and rgb_to_hex(hl.bg) or nil,
          sp = hl.sp and rgb_to_hex(hl.sp) or nil,
          bold = hl.bold,
          underline = hl.underline,
          undercurl = hl.undercurl,
          strikethrough = hl.strikethrough,
          italic = false,
        }
        vim.api.nvim_set_hl(0, group, opts)
      end

      -- Groups to disable italics for
      local italic_groups = {
        "Comment",
        "String",
        "Keyword",
        "Function",
        "Type",
        "Constant",
        "Identifier",
        "@comment",
        "@string",
        "@keyword",
        "@function",
        "@type",
        "@constant",
        "@identifier",
        "@field",
        "@property",
        "@variable",
        "@variable.builtin",
        "@parameter",
        "@attribute",
        "@lsp.typemod.variable.readonly",
        "@lsp.typemod.variable.defaultLibrary",
        "@lsp.typemod.variable.global",
      }

      -- Apply italic disabling
      for _, g in ipairs(italic_groups) do
        disable_italic(g)
      end

      -- Apply Melange highlight groups with consistent palette
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" }) -- completely transparent float
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent outside, visible inside (ui gray)
      vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#e0e0e0", bg = "NONE", bold = true }) -- Melange foreground
      vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#4a4a4a", bg = "NONE" }) -- no background to avoid artifacts
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { bg = "#2a2e3a", fg = "#e0e0e0" }) -- melange float background
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border

      -- Noice floating windows
      vim.api.nvim_set_hl(0, "NoiceFloat", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "NoiceBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      vim.api.nvim_set_hl(0, "NoicePopup", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "NoicePopupBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      -- Noice documentation floating windows
      vim.api.nvim_set_hl(0, "NoiceConfirm", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      vim.api.nvim_set_hl(0, "NoiceMini", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "NoiceMiniBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      vim.api.nvim_set_hl(0, "NoiceSplit", { bg = "NONE", fg = "#e0e0e0" }) -- transparent background
      vim.api.nvim_set_hl(0, "NoiceSplitBorder", { fg = "#4a4a4a", bg = "NONE" }) -- transparent background, visible border
      -- Separator/divider lines
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#4a4a4a", bg = "NONE" }) -- transparent separator
      vim.api.nvim_set_hl(0, "VertSplit", { fg = "#4a4a4a", bg = "NONE" }) -- transparent vertical split
      -- Documentation separators
      vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { fg = "NONE", bg = "NONE" }) -- transparent doc separator
      vim.api.nvim_set_hl(0, "NoiceDocSeparator", { fg = "NONE", bg = "NONE" }) -- transparent noice doc separator
      vim.api.nvim_set_hl(0, "SnacksIndentChunk", { fg = "#e9b963", bg = "NONE" }) -- Melange yellow color
      vim.api.nvim_set_hl(0, "TermCursor", { bg = "#4a4a4a", reverse = true }) -- ui gray color
      vim.api.nvim_set_hl(0, "TermCursorNC", { bg = "#4a4a4a" }) -- ui gray color
      -- Git diff highlights using Melange colors with better visibility
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1a2521", fg = "#8a9a7b" }) -- Dark green background, light green foreground
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#242a2e", fg = "#7eb4d3" }) -- Dark blue background, blue foreground
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#2d2528", fg = "#e57474" }) -- Dark red background, red foreground
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#2a2925", fg = "#e9b963" }) -- Dark yellow background, yellow foreground
      -- Git diff in picker/preview windows
      vim.api.nvim_set_hl(0, "SnacksPickerGitDiffAdd", { bg = "#1a2521", fg = "#8a9a7b" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitDiffChange", { bg = "#242a2e", fg = "#7eb4d3" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitDiffDelete", { bg = "#2d2528", fg = "#e57474" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitDiffText", { bg = "#2a2925", fg = "#e9b963" })
    end,
  },
}
