return {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "missing-fields" },
        globals = {
          "vim",
          "Snacks",
        },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
}
