return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
  settings = {
    complete_function_calls = true,
    typescript = {
      format = { enable = false },
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
        autoImports = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = {
          enabled = true,
          suppressWhenAnnotationIsPresent = true,
        },
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      format = { enable = false },
      inlayHints = {
        enumMemberValues = { enabled = true },
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
      },
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
  },
}