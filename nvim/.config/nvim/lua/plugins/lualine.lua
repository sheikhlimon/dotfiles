local function lsp_name()
  local buf_clients = vim.lsp.get_clients { bufnr = 0 }
  if #buf_clients == 0 then
    return ""
  end

  return "  " .. #buf_clients .. " LSP"
end

-- Recording indicator
local function recording_indicator()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "recording @" .. reg
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      always_divide_middle = true,
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "starter" },
      },
    },

    sections = {
      lualine_a = { "mode" },

      lualine_b = {
        { "branch", icon = "󰘬" },
        {
          "diff",
          colored = true,
          symbols = {
            added = " ",
            modified = " ",
            removed = " ",
          },
        },
        {
          "diagnostics",
          symbols = {
            error = "󰅚 ",
            warn = "󰀪 ",
            info = "󰋽 ",
            hint = "󰌶 ",
          },
        },
      },

      lualine_c = {
        {
          "filename",
          path = 1,
          file_status = true,
          symbols = {
            modified = "●",
            readonly = "󰌾",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
        },
        {
          recording_indicator,
          color = { fg = "#a6e3a1", gui = "bold" },
        },
      },

      lualine_x = {
        { "filetype", colored = true, icon_only = true },
        lsp_name,
      },

      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          file_status = true,
          symbols = {
            modified = "●",
            readonly = "󰌾",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
        },
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },

    extensions = {
      "nvim-tree",
      "quickfix",
      "trouble",
      "fugitive",
      "oil",
      "lazy",
      "neo-tree",
      "man",
    },
  },
}
