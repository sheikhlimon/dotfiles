return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lang = "python3",
    storage = {
      home = "~/projects/leetcode",
    },
    cache = { update_interval = 60 * 60 * 24 },
  },
}
