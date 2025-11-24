return {
  -- Rose Pine theme (currently active)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main", -- auto, main, moon, or dawn
        disable_italics = true,
        dim_inactive_windows = false,
        extend_background_behind_borders = false,
        highlight_groups = {
          CursorLine = { bg = "NONE" },
          NormalFloat = { bg = "base" },
          FloatBorder = { fg = "muted", bg = "base" },
          FloatTitle = { fg = "iris", bg = "base", bold = true },
          FloatFooter = { fg = "subtle", bg = "base" },
          BlinkCmpDoc = { bg = "base", fg = "text" },
          BlinkCmpDocBorder = { fg = "muted" },
          BlinkCmpDocCursorLine = { bg = "surface", fg = "text" },
          BlinkCmpBorder = { fg = "muted" },
          BlinkCmpMenu = { bg = "base", fg = "text" },
          BlinkCmpMenuBorder = { fg = "muted" },
          TermCursor = { bg = "muted", reverse = true },
          TermCursorNC = { bg = "muted" },
        },
      })
      vim.cmd.colorscheme "rose-pine"
    end,
  },

  -- Melange theme (alternative - comment out rose-pine config and uncomment this to use)
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
  --     vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.bg, fg = colors.fg })
  --     vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.bg, fg = colors.fg })
  --     vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "MasonBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "MasonTitle", { fg = colors.title, bold = true })
  --     vim.api.nvim_set_hl(0, "SnacksBorder", { fg = colors.border })
  --     vim.api.nvim_set_hl(0, "SnacksTitle", { fg = colors.title, bold = true })
  --     vim.api.nvim_set_hl(0, "SnacksFooter", { fg = colors.footer })
  --   end,
  -- },
}
