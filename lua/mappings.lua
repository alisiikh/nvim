local function map(n, keys, cmd, opts)
    vim.keymap.set(n, keys, cmd, opts)
end

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

map('n', '<leader>o', ':NvimTreeToggle<CR>', { desc = 'nvim-tree: Toggle', noremap = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Cursor in the middle while inserting
map('n', 'J', 'mzJ`z')

-- Move things between statements
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor in the middle when moving half page up/down
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Cursor in the middle during searches
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- cut into the copy buffer and paste keeping the buffer
map('x', '<leader>p', "\"_dP")

-- copy into system clipboard, use y not to (useful for copying outside of vim context)
map('n', '<leader>y', "\"+y")
map('v', '<leader>y', "\"+y")
map('n', '<leader>Y', "\"+Y")

map('n', '<leader>d', "\"_d")
map('v', '<leader>d', "\"_d")

map('n', 'Q', '<nop>')

-- format code
map('n', '<leader>f', function() vim.lsp.buf.format() end)

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = "go to previous diagnostic message" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "go to next diagnostic message" })
map('n', '<leader>E', vim.diagnostic.open_float, { desc = "open floating diagnostic message" })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "open diagnostics list" })

-- Git
-- map('n', '<leader>g', ':G<CR>', { desc = 'Git' })

