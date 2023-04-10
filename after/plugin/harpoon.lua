local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

local function map(n, key, f, desc)
  if desc then
    desc = 'harpoon: ' .. desc
  end
  vim.keymap.set(n, key, f, { desc = desc })
end

map('n', '<leader>h', '<Nop>', 'harpoon')
map('n', '<leader>he', ui.toggle_quick_menu, 'toggle quick menu')
map('n', '<leader>ha', mark.add_file, 'add file')
map('n', '<leader>hn', ui.nav_next, 'next file')
map('n', '<leader>hh', ui.nav_prev, 'prev file')

