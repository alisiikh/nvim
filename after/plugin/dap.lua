vim.diagnostic.config {
  virtual_text = true
}

local dap = require('dap')
local dapui = require('dapui')
local dap_widgets = require('dap.ui.widgets')

dapui.setup {}

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

local map = require('helpers').map

map("n", "<F4>", dap.toggle_breakpoint, { desc = 'dap: toggle breakpoint' })
map("n", "<F5>", dap.continue, { desc = 'dap: continue' })
map("n", "<F6>", dap.step_over, { desc = 'dap: step over' })
map("n", "<F7>", dap.step_into, { desc = 'dap: step into' })
map("n", "<F8>", dap.step_out, { desc = 'dap: step out' })
map("n", "<leader>dr", dap.repl.toggle, { desc = 'dap: repl toggle' })
map("n", "<leader>dK", dap_widgets.hover, { desc = 'dap: hover' })

local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
