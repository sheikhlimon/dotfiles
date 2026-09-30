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
  "java",
  "jsdoc",
  "json",
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
    -- Native main-branch parser installer (automatically no-ops if already installed)
    require("nvim-treesitter").install(parsers)

    -- Enable treesitter highlighting for buffers with an installed parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        -- Cap treesitter on large files to prevent input lag
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
        if ok and stats and stats.size > max_filesize then
          return -- skip treesitter for large files
        end

        if vim.treesitter.get_parser(ev.buf, nil, { error = false }) then
          vim.treesitter.start(ev.buf)
        end
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
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        check_ts = true,
      },
    },
  },
}
