local map = vim.keymap.set

-- Insert mode
map("i", "jj", "<ESC>")
map("i", "jk", "<Esc>:w<CR>", { desc = "Save buffer and exit insert mode" })

-- Normal mode
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "j", "gj", { desc = "up in wrapped line", noremap = true })
map("n", "k", "gk", { desc = "down in wrapped line", noremap = true })
map("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights" })
map("n", "<C-a>", [[:%y+<CR>]], { desc = "yank everything", silent = true })
map("n", "dae", "ggdG", { desc = "delete all content", silent = true })
map({ "n", "t" }, "<A-i>", "<Cmd>FloatermToggle<CR>", { desc = "Toggle floating terminal" })
map("n", "<leader>+", "<C-a>", { desc = "increment number" })
map("n", "<leader>-", "<C-a>", { desc = "decrement number" })
map("n", "<leader>fm", function()
  require("conform").format { async = true }
end, { desc = "Format buffer", noremap = true, silent = true })

-- spliting windows
map("n", "<leader>ss", ":vsplit<CR>", { desc = "split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "split window horizontally" })
map("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })
map("n", "<leader>sl", "<cmd>close<CR>", { desc = "close current split" })

map("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })
map(
  "n",
  "<C-f>",
  ":silent !tmux neww tmux-sessionizer<CR>",
  { desc = "Start a new tmux session in a different terminal tab" }
) --
map("n", "<leader>s", ":vsplit<CR>", { desc = "Start a new tmux session in a different terminal tab" })

-- Visual mode
map("v", "<C-c>", '"+y', { desc = "Simulates ctrl+c in windows" })
map("v", "<leader>y", '"+y', { desc = "Copy selection to clipboard" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
map("v", "<", "<gv", { desc = "Stay in indent mode when using <" })
map("v", ">", ">gv", { desc = "Stay in indent mode when using >" })
map("v", "p", '"_dP', { desc = "Whatever is yanked stays persistent even if copied on top of another word" })
