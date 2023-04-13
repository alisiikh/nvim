local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

local function map(n, key, f, desc)
  if desc then
    desc = 'harpoon: ' .. desc
  end
  vim.keymap.set(n, key, f, { desc = desc })
end

map('n', '<leader>h', ui.toggle_quick_menu, 'toggle quick menu')
map('n', '<leader>a', mark.add_file, 'add file')
map('n', '<C-h>', ui.nav_prev, 'prev file')
map('n', '<C-l>', ui.nav_next, 'next file')

