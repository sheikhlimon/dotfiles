return {
  "laytan/cloak.nvim",
  ft = { "sh" },
  config = function()
    local cloak = require "cloak"

    cloak.setup {
      enabled = true,
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

    vim.keymap.set("n", "<leader>tc", function()
      cloak.toggle()
    end, { desc = "Toggle Cloak" })
  end,
}
