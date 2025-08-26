return {
  "laytan/cloak.nvim", -- The plugin repository
  config = function()
    require("cloak").setup {
      enabled = true, -- Enable the plugin
      cloak_character = "*", -- Use '*' to replace/cloak the matched text
      highlight_group = "Comment", -- The cloaked text will be colored as comments (dimmed color)
      patterns = {
        {
          file_pattern = {
            ".env*",
            "wrangler.toml",
            ".dev.vars",
          },
          cloak_pattern = "=.+",
        },
      },
    }
  end,
}
