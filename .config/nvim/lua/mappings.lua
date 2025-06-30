require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save file" })

map("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlights" })

-- Up, Down
map("n", "j", "gj", { desc = "Up", noremap = true })
map("n", "k", "gk", { desc = "Down", noremap = true })

vim.keymap.set({ "n", "t" }, "<A-i>", "<Cmd>FloatermToggle<CR>", { desc = "Toggle floating terminal" })

map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
end)

-- J to move the current line down
map("n", "J", ":m .+1<CR>==", { desc = "move line down", noremap = true, silent = true })
-- K to move the current line up (use g? to show docs for something)
map("n", "K", ":m .-2<CR>==", { desc = "move line up", noremap = true, silent = true })

-- increment or decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "increment number" })
map("n", "<leader>-", "<C-a>", { desc = "decrement number" })

-- spliting windows
map("n", "<leader>ss", ":vsplit<CR>", { desc = "split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "split window horizontally" })
map("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })
map("n", "<leader>sl", "<cmd>close<CR>", { desc = "close current split" })

-- lsp actions
map("n", "gD", vim.lsp.buf.declaration, { desc = "go to declaration" }) -- go to declaration
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "show LSP definitions" }) -- show LSP definitions
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "show LSP implementations" }) -- show LSP implementations
map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "show LSP type definitions" }) -- show LSP type definitions
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "see available code actions" }) -- see available code actions, in visual mode will apply to selection
map("n", "<leader>srn", vim.lsp.buf.rename, { desc = "smart rename" }) -- smart rename
map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "show buffer diagnostics" }) -- show diagnostics for file
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "show line diagnostics" }) -- show diagnostics for line
-- keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "go to previous diagnostic" }) -- jump to previous diagnostic in buffer
-- keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "go to next diagnostic" }) -- jump to next diagnostic in buffer
map("n", "g?", vim.lsp.buf.hover, { desc = "show documentation for what is under cursor" }) -- show documentation for what is under cursor
-- keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "restart LSP" }) -- mapping to restart lsp if necessary
