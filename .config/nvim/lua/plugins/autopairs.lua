return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- enable Treesitter-aware pairing
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
  end,
}
