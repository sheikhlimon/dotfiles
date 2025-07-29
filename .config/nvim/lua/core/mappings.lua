local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode
map("i", "jj", "<ESC>")
map("i", "jk", "<Esc>:w<CR>", { desc = "Save buffer and exit insert mode" })

-- better j/k
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- comment
map({ "i", "n", "v" }, "<C-_>", "<cmd>normal gcc<cr>", opts)

-- Normal mode
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights" })
map("n", "<C-a>", [[:%y+<CR>]], { desc = "yank everything", silent = true })
map("n", "dae", "ggdG", { desc = "delete all content", silent = true })
map("n", "<leader>fm", function()
  require("conform").format { async = true }
end, { desc = "Format buffer", noremap = true, silent = true })

-- spliting windows
map("n", "<leader>ss", ":vsplit<CR>", { desc = "split window vertically" })
map("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })
map("n", "<leader>sl", "<cmd>close<CR>", { desc = "close current split" })

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize +2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize -2<CR>", opts)

map("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

-- Visual mode
map("v", "<C-c>", '"+y', { desc = "Simulates ctrl+c in windows" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
map("v", "<", "<gv", { desc = "Stay in indent mode when using <" })
map("v", ">", ">gv", { desc = "Stay in indent mode when using >" })
map("v", "p", '"_dP', { desc = "Whatever is yanked stays persistent even if copied on top of another word" })
