return {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
}