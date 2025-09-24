local opts = { noremap = true, silent = true }

-- Insert mode
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>:w<CR>", { desc = "Save buffer and exit insert mode" })

-- save file without auto-formatting
vim.keymap.set("i", "kj", "<Esc>:noautocmd w <CR>", opts)

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- better j/k
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":Bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Normal mode
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered and unfolded" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered and unfolded" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights" })
vim.keymap.set("n", "<C-a>", [[:%y+<CR>]], { desc = "yank everything", silent = true })
vim.keymap.set("n", "dae", "ggdG", { desc = "delete all content", silent = true })
vim.keymap.set("n", "<leader>j", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace all occurrences of word under cursor",
})

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>o", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>c", ":close<CR>", opts) -- close current split window

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", opts)

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Visual mode
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Simulates ctrl+c in windows" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
vim.keymap.set("v", "<", "<gv", { desc = "Stay in indent mode when using <" })
vim.keymap.set("v", ">", ">gv", { desc = "Stay in indent mode when using >" })
vim.keymap.set("v", "p", '"_dP', { desc = "Whatever is yanked stays persistent even if copied on top of another word" })
