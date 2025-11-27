local util = require "lspconfig.util"

return {
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
    },
  },
  filetypes = { "sh", "zsh" },
  root_dir = util.find_git_ancestor,
  single_file_support = true,
}

