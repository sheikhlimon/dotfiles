return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup {
      variant = "auto", -- Automatically selects 'main' or 'moon' based on your background
      dark_variant = "moon", -- Fallback if 'variant' is set to 'auto'
      styles = {
        bold = false,
        italic = false,
        transparency = true, -- Enables transparency
      },
      disable_background = true, -- Makes the background transparent
    }
    vim.cmd "colorscheme rose-pine"
  end,
}
