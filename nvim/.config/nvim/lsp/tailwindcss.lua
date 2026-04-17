return {
  settings = {
    tailwindCSS = {
      emmetCompletions = true,
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = { "class", "className", "classList", "ngClass", ":class" },
      experimental = {
        classRegex = {
          "tw`([^`]*)`",
          "tw\\(([^)]*)\\)",
          "@apply\\s+([^;]*)",
          'class="([^"]*)"',
          'className="([^"]*)"',
          ':class="([^"]*"',
          "@class\\(([^)]*)\\)",
        },
      },
    },
  },
}
