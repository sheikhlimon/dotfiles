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
      -- Common color definitions
      local colors = {
        bg = "#1F1F28",
        fg = "#dcd7ba",
        fg_dim = "#727169",
        border = "#4A4A5A",
        selection = "#403a36",
        scrollbar = "#2A2A38",
        title = "#c8c093",
        footer = "#727169",
      }

      -- Disable italics immediately
      for _, g in ipairs(groups) do
        disable_italic(g)
      end

      -- Base editor colors
      vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = colors.bg, fg = colors.fg_dim })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.border, bg = "none" })

      -- Popup menus
      vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.bg, fg = colors.fg })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.selection, fg = colors.fg, bold = true })
      vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.scrollbar })
      vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.border })

      -- Blink.cmp highlights
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.bg, fg = colors.fg })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.border })
      vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { bg = colors.selection, fg = colors.fg })
      vim.api.nvim_set_hl(0, "BlinkCmpBorder", { fg = colors.border })
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.bg, fg = colors.fg })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.border })

      -- Mason.nvim highlights
      vim.api.nvim_set_hl(0, "MasonBorder", { fg = colors.border })
      vim.api.nvim_set_hl(0, "MasonTitle", { fg = colors.title, bold = true })

      -- Snacks.nvim integration
      vim.api.nvim_set_hl(0, "SnacksBorder", { fg = colors.border })
      vim.api.nvim_set_hl(0, "SnacksTitle", { fg = colors.title, bold = true })
      vim.api.nvim_set_hl(0, "SnacksFooter", { fg = colors.footer })
      vim.api.nvim_set_hl(0, "SnacksBackdrop", { bg = "#000000", blend = 60 })

      -- Floating window highlights
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.bg })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.border })
      vim.api.nvim_set_hl(0, "FloatTitle", { fg = colors.title, bold = true })
      vim.api.nvim_set_hl(0, "FloatFooter", { fg = colors.footer })
      vim.api.nvim_set_hl(0, "WindowBorder", { fg = colors.border })
      vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.border })
      -- Noice-specific highlights
      vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = colors.footer, bold = true })
      vim.api.nvim_set_hl(0, "NoiceLspProgressMessage", { fg = "#808090" })

      -- Terminal colors
      vim.api.nvim_set_hl(0, "TermCursor", { bg = "#5A5A6A", reverse = true })
      vim.api.nvim_set_hl(0, "TermCursorNC", { bg = "#5A5A6A" })
    end,
  },
}
