local parsers = {
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "sql",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Auto-install missing parsers in the background (non-blocking)
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok then
      local installed = ts.get_installed()
      local missing = vim.iter(parsers)
        :filter(function(p)
          return not vim.tbl_contains(installed, p)
        end)
        :totable()
      if #missing > 0 then
        ts.install(missing)
      end
    end

    -- Enable treesitter highlighting only for languages we have parsers for
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
      desc = "Enable treesitter highlighting",
    })

    -- Enable treesitter-based indentation
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
      desc = "Enable treesitter indentation",
    })
  end,
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      ft = { "html", "typescript", "typescriptreact", "tsx", "vue", "svelte" },
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
  },
}
