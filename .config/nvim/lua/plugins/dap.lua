return {
  "mfussenegger/nvim-dap",
  keys = { "<leader>b", "<leader>nn" },
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")
    ui.setup()

    vim.keymap.set("n", "<leader>b", function()
      dap.toggle_breakpoint()
    end)
    vim.keymap.set("n", "<leader>nn", function()
      dap.continue()
    end)
    vim.keymap.set("n", "<leader>si", function()
      dap.step_into()
    end)
    vim.keymap.set("n", "<leader>so", function()
      dap.step_over()
    end)
    vim.keymap.set("n", "<leader>so", function()
      dap.step_out()
    end)
    vim.keymap.set("n", "<space>?", function()
      ui.eval(nil, { enter = true })
    end)

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end,
}
