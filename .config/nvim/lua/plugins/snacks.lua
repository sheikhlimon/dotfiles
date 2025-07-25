return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,

	config = function()
		local snacks = require("snacks")
		snacks.setup({
			lazygit = {},
			bigfile = { size = 1024 * 1024 },
			word = { enabled = true },
			scroll = { enabled = true },
			indent = {
				indent = { enabled = false },
				animate = {
					duration = {
						step = 30,
						total = 200,
					},
				},
				chunk = {
					enabled = true,
					char = {
						corner_top = "╭",
						corner_bottom = "╰",
						arrow = ">",
					},
				},
			},
			input = {
				icon = "::",
				win = {
					width = 35,
					relative = "cursor",
					row = -3, -- puts prompt on top of cursor
					col = 0,
				},
			},
			picker = {
				prompt = " :: ",
				sources = {
					explorer = {
						exclude = { ".node_modules*", ".DS_Store" },
						include = { ".*" },
					},
					files = {
						exclude = { ".node_modules*", ".DS_Store" },
						include = { ".git*", ".go*", ".config", ".local", ".cache" },
					},
					todo_comments = {
						exclude = { "*.ics" },
						include = {},
					},
				},
			},
		})

		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
		end

		-- === Pickers === --
		map("n", "<leader>fg", snacks.picker.grep, "Live Grep")
		map("n", "<leader>ff", snacks.picker.files, "Find Files")
		map("n", "<leader>fr", snacks.picker.recent, "Recent Files")
		map("n", "<leader>fh", snacks.picker.help, "Help Pages")
		map("n", "<leader>r", snacks.picker.registers, "Registers")
		map("n", "<leader>th", snacks.picker.colorschemes, "Theme Picker")

		-- === Reference Navigation === --
		map({ "n", "t" }, "]]", function()
			snacks.words.jump(vim.v.count1)
		end, "Next Reference")

		map({ "n", "t" }, "[[", function()
			snacks.words.jump(-vim.v.count1)
		end, "Previous Reference")

		-- === Git === --
		map("n", "<leader>gf", snacks.picker.git_diff, "Git Status")
		map("n", "<leader>gg", snacks.lazygit.open, "Lazy Git")

		-- === LSP === --
		map("n", "gd", snacks.picker.lsp_definitions, "Goto Definition")
		map("n", "gr", snacks.picker.lsp_references, "Goto References")
		map("n", "gI", snacks.picker.lsp_implementations, "Goto Implementations")
		map("n", "<leader>fd", snacks.picker.diagnostics, "Workspace Diagnostics")

		map("n", "<leader>pp", ":lua Snacks.picker() <cr>", "opens a list of of pickers to choose from")
		map("n", "<leader>to", function()
			snacks.picker("todo_comments")
		end, "Find Todo comments")
	end,
}
