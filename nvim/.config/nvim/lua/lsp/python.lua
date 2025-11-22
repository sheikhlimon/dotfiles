return {
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
}