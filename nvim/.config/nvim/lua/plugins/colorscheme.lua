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
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" }) -- main editor cursor line stays transparent
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "#1F1F28" })

      -- Floating windows
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1F1F28", fg = "#444444" })

      -- Popup menus
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#333444" })
    end,
  },
}
