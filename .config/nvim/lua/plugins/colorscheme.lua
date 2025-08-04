return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = function()
    require("rose-pine").setup {
      variant = "moon",
      dark_variant = "moon",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },

      styles = {
        bold = false,
        italic = false,
        transparency = true,
      },

      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",
      },

      highlight_groups = {
        -- Transparency overrides - BACK TO TRANSPARENT
        Normal = { bg = "none" },
        NormalFloat = { bg = "#191724" }, -- FIXED: Force dark background for floats
        NormalNC = { bg = "none" },
        CursorLine = { bg = "none" },
        CursorColumn = { bg = "none" },
        ColorColumn = { bg = "none" },
        SignColumn = { bg = "none" },
        Folded = { bg = "none" },
        FoldColumn = { bg = "none" },
        LineNr = { bg = "none" },
        CursorLineNr = { bg = "none" },
        EndOfBuffer = { bg = "none" },

        -- Window separators
        WinSeparator = { fg = "muted", bg = "none" },
        VertSplit = { fg = "muted", bg = "none" },

        -- Popup menus - FIXED: Force dark black backgrounds
        Pmenu = { fg = "subtle", bg = "#191724" }, -- Completion menu - dark black
        PmenuSel = { fg = "text", bg = "#26233a" }, -- Selected item - slightly lighter
        PmenuSbar = { bg = "#191724" },
        PmenuThumb = { bg = "#26233a" },

        -- Command line and wildmenu - FIXED
        WildMenu = { fg = "text", bg = "#191724" },
        CmdlinePopup = { fg = "subtle", bg = "#191724" },

        -- Blink.cmp specific overrides - FORCE BLACK
        BlinkCmpMenu = { fg = "subtle", bg = "#191724" },
        BlinkCmpMenuBorder = { fg = "muted", bg = "#191724" },
        BlinkCmpMenuSelection = { fg = "text", bg = "#26233a" },
        BlinkCmpLabel = { fg = "text" },
        BlinkCmpLabelDetail = { fg = "subtle" },
        BlinkCmpKind = { fg = "rose" },

        -- Float borders - FORCE BLACK
        FloatBorder = { fg = "muted", bg = "#191724" },

        -- LSP and diagnostics (no bold/italic)
        DiagnosticError = { fg = "love" },
        DiagnosticWarn = { fg = "gold" },
        DiagnosticInfo = { fg = "foam" },
        DiagnosticHint = { fg = "iris" },
        DiagnosticVirtualTextError = { fg = "love", bg = "none" },
        DiagnosticVirtualTextWarn = { fg = "gold", bg = "none" },
        DiagnosticVirtualTextInfo = { fg = "foam", bg = "none" },
        DiagnosticVirtualTextHint = { fg = "iris", bg = "none" },

        -- FIXED Tree-sitter overrides
        ["@keyword"] = { fg = "pine" },
        ["@keyword.function"] = { fg = "pine" },
        ["@keyword.operator"] = { fg = "subtle" },
        ["@keyword.return"] = { fg = "pine" },
        ["@keyword.conditional"] = { fg = "pine" },

        -- Functions
        ["@function"] = { fg = "rose" },
        ["@function.call"] = { fg = "rose" },
        ["@function.builtin"] = { fg = "love" },
        ["@method"] = { fg = "rose" },
        ["@method.call"] = { fg = "rose" },

        -- Variables - Variables should be white
        ["@variable"] = { fg = "text" },
        ["@variable.member"] = { fg = "text" },
        ["@variable.parameter"] = { fg = "text" },
        ["@variable.builtin"] = { fg = "foam" },
        ["@parameter"] = { fg = "text" },
        ["@lsp.type.parameter"] = { fg = "text" },
        ["@lsp.type.variable"] = { fg = "text" },
        ["@lsp.type.namespace"] = { fg = "text" },
        ["@module"] = { fg = "text" },

        -- Constants - Regular constants white, built-ins cyan
        ["@constant"] = { fg = "text" },
        ["@constant.builtin"] = { fg = "foam" },

        -- Types
        ["@type"] = { fg = "foam" },
        ["@type.builtin"] = { fg = "love" },

        -- Literals
        ["@string"] = { fg = "gold" },
        ["@string.escape"] = { fg = "rose" },
        ["@character"] = { fg = "gold" },
        ["@number"] = { fg = "iris" },
        ["@boolean"] = { fg = "rose" },

        -- Properties
        ["@property"] = { fg = "iris" },
        ["@field"] = { fg = "iris" },

        -- Comments
        ["@comment"] = { fg = "muted" },

        -- Operators
        ["@operator"] = { fg = "subtle" },

        -- Punctuation
        ["@punctuation.delimiter"] = { fg = "subtle" },
        ["@punctuation.bracket"] = { fg = "foam" }, -- Changed from subtle to foam - makes {} cyan
        ["@punctuation.special"] = { fg = "rose" },

        -- Force all brackets to be muted gray
        ["@punctuation.bracket.curly"] = { fg = "foam" }, -- {} cyan

        -- Alternative bracket overrides
        ["Delimiter"] = { fg = "muted" },
        ["@constructor"] = { fg = "muted" },
        ["@namespace"] = { fg = "pine" },

        -- Markup
        ["@markup.heading"] = { fg = "love" },
        ["@markup.strong"] = { fg = "text" },
        ["@markup.italic"] = { fg = "text" },

        -- Statusline transparency
        StatusLine = { bg = "none" },
        StatusLineNC = { bg = "none" },

        -- Tabline transparency
        TabLine = { bg = "none" },
        TabLineFill = { bg = "none" },
        TabLineSel = { bg = "#191724" },

        -- Git signs
        GitSignsAdd = { fg = "foam", bg = "none" },
        GitSignsChange = { fg = "rose", bg = "none" },
        GitSignsDelete = { fg = "love", bg = "none" },

        -- Which-key transparency
        WhichKey = { bg = "none" },
        WhichKeyFloat = { bg = "#191724" },

        -- Neo-tree transparency
        NeoTreeNormal = { bg = "none" },
        NeoTreeNormalNC = { bg = "none" },
        NeoTreeEndOfBuffer = { bg = "none" },

        -- Lazy.nvim - force black
        LazyNormal = { bg = "#191724" },

        -- Mason - force black
        MasonNormal = { bg = "#191724" },
      },
    }

    -- Set colorscheme
    vim.cmd "colorscheme rose-pine-moon"

    -- Force transparency and black backgrounds after theme loads
    vim.schedule(function()
      -- Main editor transparency
      vim.cmd "hi Normal guibg=NONE ctermbg=NONE"
      vim.cmd "hi NormalNC guibg=NONE ctermbg=NONE"
      vim.cmd "hi SignColumn guibg=NONE ctermbg=NONE"
      vim.cmd "hi LineNr guibg=NONE ctermbg=NONE"
      vim.cmd "hi Folded guibg=NONE ctermbg=NONE"
      vim.cmd "hi NonText guibg=NONE ctermbg=NONE"
      vim.cmd "hi SpecialKey guibg=NONE ctermbg=NONE"
      vim.cmd "hi VertSplit guibg=NONE ctermbg=NONE"
      vim.cmd "hi EndOfBuffer guibg=NONE ctermbg=NONE"

      -- Force black backgrounds for UI elements
      vim.cmd "hi NormalFloat guibg=#191724 ctermbg=NONE"
      vim.cmd "hi FloatBorder guibg=#191724 ctermbg=NONE"
      vim.cmd "hi Pmenu guibg=#191724 ctermbg=NONE"
      vim.cmd "hi PmenuSel guibg=#26233a ctermbg=NONE"
      vim.cmd "hi BlinkCmpMenu guibg=#191724 ctermbg=NONE"
      vim.cmd "hi BlinkCmpMenuBorder guibg=#191724 ctermbg=NONE"
      vim.cmd "hi BlinkCmpMenuSelection guibg=#26233a ctermbg=NONE"
    end)
  end,
}
