return {
  filetypes = {
    "html",
    "blade",
    "javascriptreact",
    "typescriptreact",
    "svelte",
  },
  root_markers = { "index.html", ".git" },
  init_options = { provideFormatter = false },
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
}