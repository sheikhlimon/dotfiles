return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      ft = { "html", "typescript", "typescriptreact", "vue", "svelte" },
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
  },
  opts = {
    ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "regex",
      "go",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "ruby" }, -- optional, remove if not needed
    },
    indent = {
      enable = true,
      disable = { "ruby" },
    },
  },
}
