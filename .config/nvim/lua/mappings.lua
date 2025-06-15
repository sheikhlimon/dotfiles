require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })

-- Up, Down
map("n", "j", "gj", { desc = "Up", noremap = true })
map("n", "k", "gk", { desc = "Down", noremap = true })

map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
end)
