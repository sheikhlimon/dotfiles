return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local mason_registry = require("mason-registry")
        local jdtls_pkg = mason_registry.get_package("jdtls")
        local jdtls_path = jdtls_pkg:get_install_path()
        local lombok_path = jdtls_path .. "/lombok.jar"
        
        -- nvim-jdtls requires workspace folders
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

        -- Collect DAP bundles
        local bundles = {}
        if mason_registry.has_package("java-debug-adapter") then
          local java_debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
          vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"))
        end
        if mason_registry.has_package("java-test") then
          local java_test_path = mason_registry.get_package("java-test"):get_install_path()
          vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))
        end

        local config = {
          cmd = {
            "jdtls",
            "--jvm-arg=-javaagent:" .. lombok_path,
            "-data", workspace_dir,
          },
          root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"}),
          init_options = {
            bundles = bundles,
          },
          on_attach = function(client, bufnr)
            -- Setup DAP and discover main classes
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs()

            -- Java Test keymaps
            vim.keymap.set("n", "<leader>jc", require("jdtls").test_class, { buffer = bufnr, desc = "Test Class (Java)" })
            vim.keymap.set("n", "<leader>jm", require("jdtls").test_nearest_method, { buffer = bufnr, desc = "Test Method (Java)" })
          end,
          settings = {
            java = {
              eclipse = {
                downloadSources = true,
              },
              configuration = {
                updateBuildConfiguration = "interactive",
              },
              maven = {
                downloadSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              references = {
                includeDecompiledSources = true,
              },
              inlayHints = {
                parameterNames = {
                  enabled = "all", -- literals, all, none
                },
              },
            }
          },
        }

        require("jdtls").start_or_attach(config)
      end,
    })
  end,
}
