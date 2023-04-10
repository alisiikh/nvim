function setup()
    function keymap(n, keys, cmd, opts)
        vim.keymap.set(n, keys, cmd, opts)
    end

    -- Keymaps for better default experience
    -- See `:help vim.keymap.set()`
    keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

    -- Remap for dealing with word wrap
    keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- Diagnostic keymaps
    
    keymap('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
    keymap('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
    keymap('n', '<leader>E', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
    keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

    -- NvimTree keymaps
    keymap('n', '<leader>o', ':NvimTreeToggle<cr>', { desc = "Toggle file tree (NvimTree)" })

    -- Telescope
    -- See `:help telescope.builtin`
    local telescope = require('telescope.builtin')

    keymap('n', '<leader>?', telescope.oldfiles, { desc = '[?] Find recently opened files' })
    keymap('n', '<leader><space>', telescope.buffers, { desc = '[ ] Find existing buffers' })
    keymap('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })
    keymap('n', '<leader>s', '<Nop>', { desc = '[S]earch (Telescope)' })
    keymap('n', '<leader>sf', telescope.find_files, { desc = '[S]earch [F]iles' })
    keymap('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
    keymap('n', '<leader>sw', telescope.grep_string, { desc = '[S]earch current [W]ord' })
    keymap('n', '<leader>sg', telescope.live_grep, { desc = '[S]earch by [G]rep' })
    keymap('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
end

return {
    setup = setup
}
