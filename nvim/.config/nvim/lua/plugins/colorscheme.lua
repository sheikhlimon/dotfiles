return {
  {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
      -- Load melange colorscheme
      vim.cmd "colorscheme melange"

      -- Disable italics for main groups but keep their colors
      local italic_off_groups = {
        -- Standard syntax groups
        "Comment",
        "String",
        "Keyword",
        "Function",
        "Type",
        "Constant",
        "Identifier",

        -- Treesitter groups
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

        -- LSP semantic tokens (some themes apply italics here)
        "@lsp.typemod.variable.readonly",
        "@lsp.typemod.variable.defaultLibrary",
        "@lsp.typemod.variable.global",
      }

      for _, group in ipairs(italic_off_groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok and hl then
          local opts = {}
          if hl.fg then
            opts.fg = hl.fg
          end
          if hl.bg then
            opts.bg = hl.bg
          end
          opts.italic = false
          vim.api.nvim_set_hl(0, group, opts)
        end
      end

      -- Set custom background color
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1F1F28", fg = "#444444" }) -- you can tweak fg
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1F1F28" }) -- completion menu
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a2a2a" }) -- selected item
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "#1F1F28", fg = "#444444" }) -- window split line
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("kanagawa").setup {
        compile = false,
        transparent = true,
        dimInactive = true,
        undercurl = true,
        terminalColors = true,
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { bold = false },
        typeStyle = {},
        functionStyle = {},
        variablebuiltinStyle = { italic = false },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          local palette = colors.palette
          return {
            -- UI tweaks
            IndentBlanklineChar = { fg = palette.waveBlue2 },
            MiniIndentscopeSymbol = { fg = palette.waveBlue2 },
            PmenuSel = { blend = 0 },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            CursorLineNr = { bg = theme.ui.bg_p2 },
            Visual = { bg = palette.waveBlue2 },

            -- Darker float windows
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      }

      -- Load the colorscheme
      -- vim.cmd "colorscheme kanagawa"
    end,
  },
}
