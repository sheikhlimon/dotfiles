local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

return {
  filetypes = { "java" },
  root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
  handlers = {
    -- Mute the notoriously noisy non-standard JDTLS progress messages
    ["language/status"] = function() end,
  },
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
