return {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  cmd = { "clangd", "--background-index", "--clang-tidy" },
}