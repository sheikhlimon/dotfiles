return {
  filetypes = { "go", "gomod" },
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        nilness = true,
        shadow = true,
        unusedwrite = true,
      },
      staticcheck = true,
      codelenses = {
        generate = true,
        gc_details = true,
        tidy = true,
      },
    },
  },
}