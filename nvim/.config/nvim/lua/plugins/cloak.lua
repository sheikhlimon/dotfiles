return {
  "laytan/cloak.nvim",
  config = function()
    local cloak = require "cloak"

    cloak.setup {
      enabled = true, -- Cloak starts enabled
      cloak_character = "*",
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = { ".env*", "*/.env*" },
          cloak_pattern = "=.+", -- everything after '='
        },
      },
    }

    -- Create a toggle command
    vim.api.nvim_create_user_command("CloakToggle", function()
      cloak.toggle()
    end, {})

    -- Optional keybinding for toggle
    vim.keymap.set("n", "<leader>tc", function()
      cloak.toggle()
    end, { desc = "Toggle Cloak" })
  end,
}
