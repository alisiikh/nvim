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

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = "go to previous diagnostic message" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "go to next diagnostic message" })
map('n', '<leader>E', vim.diagnostic.open_float, { desc = "open floating diagnostic message" })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "open diagnostics list" })

