local dap = require('dap')
local dapui = require('dapui')
local dap_widgets = require('dap.ui.widgets')

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

dapui.setup {}
