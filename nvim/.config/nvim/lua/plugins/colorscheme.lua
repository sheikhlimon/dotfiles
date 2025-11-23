return {
  -- Colorscheme: melange with italics disabled
  {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "melange"
      -- Utility to convert RGB to hex
      local function rgb_to_hex(v)
        if type(v) == "number" then
          return string.format("#%06x", v)
        end
        return v
      end
      -- Disable italics for groups
      local function disable_italic(group)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if not ok or not hl or vim.tbl_isempty(hl) then
          return
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
      local groups = {
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
      -- Disable italics immediately
      for _, g in ipairs(groups) do
        disable_italic(g)
      end
      -- Base editor colors
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1F1F28", fg = "#E8E8E8" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1F1F28", fg = "#C8C8C8" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#4A4A5A", bg = "none" })
      -- Popup menus
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1F1F28", fg = "#E8E8E8" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3D3D4D", fg = "#FFFFFF", bold = true })
      vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#2A2A38" })
      vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#4A4A5A" })

      -- Blink.cmp specific highlights - improved contrast
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1F1F28", fg = "#E8E8E8" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#4A4A5A" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#3D3D4D", fg = "#FFFFFF", bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#E8E8E8" })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#A0C0D0", bold = true, underline = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#B0B0C0" })
      vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = "#707080" })
      vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#606070", italic = false })

      -- Blink.cmp documentation window
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#1F1F28", fg = "#E8E8E8" })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#4A4A5A" })
      vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { bg = "#2A2A38" })

      -- Mason.nvim highlights - only override what's needed for borders
      vim.api.nvim_set_hl(0, "MasonBorder", { fg = "#4A4A5A" })
      vim.api.nvim_set_hl(0, "MasonTitle", { fg = "#FFFFFF", bold = true })

      -- Snacks.nvim integration - inherit from base groups where possible
      vim.api.nvim_set_hl(0, "SnacksBorder", { fg = "#4A4A5A" })
      vim.api.nvim_set_hl(0, "SnacksTitle", { fg = "#FFFFFF", bold = true })
      vim.api.nvim_set_hl(0, "SnacksFooter", { fg = "#A0A0B0" })
      vim.api.nvim_set_hl(0, "SnacksBackdrop", { bg = "#000000", blend = 60 })
      -- Professional floating window highlights
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#E8E8E8", bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4A4A5A" })
      vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#FFFFFF", bold = true })
      -- Additional border and window highlights to prevent overflow
      vim.api.nvim_set_hl(0, "FloatFooter", { fg = "#A0A0B0" })
      vim.api.nvim_set_hl(0, "WindowBorder", { fg = "#4A4A5A" })
      vim.api.nvim_set_hl(0, "VertSplit", { fg = "#4A4A5A" })
      -- Noice-specific highlights for better readability
      vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = "#A0A0B0", bold = true })
      vim.api.nvim_set_hl(0, "NoiceLspProgressMessage", { fg = "#808090" })

      -- Terminal colors
      vim.api.nvim_set_hl(0, "TermCursor", { bg = "#5A5A6A", reverse = true })
      vim.api.nvim_set_hl(0, "TermCursorNC", { bg = "#5A5A6A" })
    end,
  },
}
