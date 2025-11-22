return {
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}