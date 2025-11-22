return {
  root_markers = { "Cargo.lock" },
  filetypes = { "rust" },
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}