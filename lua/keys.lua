function setup()
    function map(n, keys, cmd, opts)
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
    map('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
    map('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
    map('n', '<leader>E', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
    map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

    -- Telescope
    -- See `:help telescope.builtin`
    local telescope = require('telescope.builtin')
    map('n', '<leader>?', telescope.oldfiles, { desc = '[?] Find recently opened files' })
    map('n', '<leader><space>', telescope.buffers, { desc = '[ ] Find existing buffers' })
    map('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })
    map('n', '<leader>s', '<Nop>', { desc = '[S]earch (Telescope)' })
    map('n', '<leader>sf', telescope.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sw', telescope.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', telescope.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
end

return {
    setup = setup
}
