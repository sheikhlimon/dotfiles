local function recording_indicator()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "Recording @" .. reg
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      statusline = {},
      winbar = {},
      -- disabled_filetypes = { "NvimTree" },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      -- and statusline for the last active window is used.
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        { "filename", path = 1 },
        { recording_indicator, color = { fg = "#a6e3a1", gui = "bold" } },
        -- {
        --   'lsp_progress', -- Shows LSP progress messages
        --   display_components = {'lsp_client_name', 'progress'},
        --   colors = { MaterialDark = { progress_done =โซ '#a6e3a1' } },
        -- },
        -- {
        --  'searchcount',
        --  max_searches = 999, -- Maximum number of search results to display
        --  timeout = 500,      -- Timeout in milliseconds for search results
        -- },
      },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {
      "nvim-tree",
      -- "toggleterm",
      "quickfix",
      -- "mason",
      -- 'fugitive', -- Example for git blame
      -- {
      --   'nvim-dap-ui',
      --   sections = {lualine_c = {'dap-state', 'dap-session'}}
      -- }
    },
  },
}
