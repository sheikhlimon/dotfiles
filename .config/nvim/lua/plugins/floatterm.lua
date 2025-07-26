return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  opts = {
    border = false,
    size = { h = 60, w = 70 },

    -- to use, make this func(buf)
    mappings = {
      term = function(buf)
        vim.keymap.set({ "n", "t" }, "<C-p>", function()
          require("floaterm.api").cycle_term_bufs("prev")
        end, { buffer = buf, desc = "Cycle terminal: prev" })
      end,
    },

    -- Default sets of terminals you'd like to open
    terminals = {
      { name = "Terminal" },
    },
  },
  cmd = "FloatermToggle",
}
