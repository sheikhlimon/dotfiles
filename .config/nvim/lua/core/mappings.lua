local opts = { noremap = true, silent = true }

-- Insert mode
vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("i", "jk", "<Esc>:w<CR>", { desc = "Save buffer and exit insert mode" })

-- better j/k
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- comment
vim.keymap.set({ "i", "n", "v" }, "<C-_>", "<cmd>normal gcc<cr>", opts)

-- Normal mode
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered and unfolded" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered and unfolded" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
vim.keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights" })
vim.keymap.set("n", "<C-a>", [[:%y+<CR>]], { desc = "yank everything", silent = true })
vim.keymap.set("n", "dae", "ggdG", { desc = "delete all content", silent = true })
vim.keymap.set("n", "<leader>fm", function()
  require("conform").format { async = true }
end, { desc = "Format buffer", noremap = true, silent = true })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace all occurrences of word under cursor",
})

-- spliting windows
vim.keymap.set("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })
vim.keymap.set("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", opts)

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

-- Visual mode
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Simulates ctrl+c in windows" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
vim.keymap.set("v", "<", "<gv", { desc = "Stay in indent mode when using <" })
vim.keymap.set("v", ">", ">gv", { desc = "Stay in indent mode when using >" })
vim.keymap.set("v", "p", '"_dP', { desc = "Whatever is yanked stays persistent even if copied on top of another word" })
