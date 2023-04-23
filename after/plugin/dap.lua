vim.diagnostic.config {
  virtual_text = true
}

local dap = require('dap')
local dapui = require('dapui')
local dap_widgets = require('dap.ui.widgets')

dapui.setup {}

local function map(n, keys, cmd, opts)
  vim.keymap.set(n, keys, cmd, opts)
end

map("n", "<F5>", dap.continue, { desc = 'dap: continue' })
map("n", "<F10>", dap.step_over, { desc = 'dap: step over' })
map("n", "<F11>", dap.step_into, { desc = 'dap: step into' })
map("n", "<F12>", dap.step_out, { desc = 'dap: step out' })
map("n", "<leader>dr", dap.repl.toggle, { desc = 'dap: repl toggle' })
map("n", "<leader>b", dap.toggle_breakpoint, { desc = 'dap: toggle breakpoint' })
map("n", "<leader>dK", dap_widgets.hover, { desc = 'dap: hover' })
-- map("n", "<leader>drl", dap.run_last, { desc = 'dap: run last' })

local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})
