return {
  {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "melange"

      -- Convert number to #RRGGBB hex
      local function rgb_to_hex(v)
        if type(v) == "number" then
          return string.format("#%06x", v)
        end
        return v
      end

      -- Disable italics for one group
      local function disable_italic(group)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if not ok or not hl or vim.tbl_isempty(hl) then
          return
        end

        local opts = {}
        if hl.fg then
          opts.fg = rgb_to_hex(hl.fg)
        end
        if hl.bg then
          opts.bg = rgb_to_hex(hl.bg)
        end
        if hl.sp then
          opts.sp = rgb_to_hex(hl.sp)
        end
        opts.bold = hl.bold
        opts.underline = hl.underline
        opts.undercurl = hl.undercurl
        opts.strikethrough = hl.strikethrough
        opts.italic = false

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

      -- use a short delay after ColorScheme to override italics
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "melange",
        callback = function()
          vim.defer_fn(function()
            for _, g in ipairs(groups) do
              disable_italic(g)
            end
          end, 100)
        end,
      })

      -- run immediately, in case melange is already loaded
      vim.defer_fn(function()
        for _, g in ipairs(groups) do
          disable_italic(g)
        end
      end, 200)

      -- Optional: custom background tweaks
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1F1F28", fg = "#444444" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a2a2a" })
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "#1F1F28", fg = "#444444" })
    end,
  },
}
