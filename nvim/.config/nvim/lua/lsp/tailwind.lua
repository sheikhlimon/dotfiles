return {
  filetypes = {
    "html",
    "css",
    "scss",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.ts",
    "package.json",
    ".git",
  },
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
          ':class="([^"]*)"',
          "@class\\(([^)]*)\\)",
        },
      },
    },
  },
}