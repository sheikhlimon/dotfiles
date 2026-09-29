return {
  cmd = function()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name
    return {
      "jdtls",
      "-configuration", vim.fn.stdpath("cache") .. "/jdtls/config",
      "-data", workspace_dir,
    }
  end,
  settings = {
    java = {
      eclipse = {
        downloadSources = false,
      },
      maven = {
        downloadSources = false,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
    }
  }
}
