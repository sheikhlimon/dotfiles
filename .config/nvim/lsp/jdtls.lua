local mason_registry = require("mason-registry")
local jdtls_pkg = mason_registry.get_package("jdtls")
local jdtls_path = jdtls_pkg:get_install_path()
local lombok_path = jdtls_path .. "/lombok.jar"

return {
  cmd = {
    "jdtls",
    "--jvm-arg=-javaagent:" .. lombok_path,
  },
}
