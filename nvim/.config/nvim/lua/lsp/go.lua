return {
  filetypes = { "go", "gomod", "gosum" },
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