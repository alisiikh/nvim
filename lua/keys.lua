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
    map('n', '[d', vim.diagnostic.goto_prev, { desc = "go to previous diagnostic message" })
    map('n', ']d', vim.diagnostic.goto_next, { desc = "go to next diagnostic message" })
    map('n', '<leader>E', vim.diagnostic.open_float, { desc = "open floating diagnostic message" })
    map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "open diagnostics list" })

    -- Telescope
    -- See `:help telescope.builtin`
    local telescope = require('telescope.builtin')
    map('n', '<leader>?', telescope.oldfiles, { desc = 'find recently opened files' })
    map('n', '<leader><space>', telescope.buffers, { desc = 'find existing buffers' })
    map('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      local themes = require('telescope.themes')
      telescope.current_buffer_fuzzy_find(themes.get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Fuzzily search in current buffer' })
    map('n', '<leader>s', '<Nop>', { desc = 'telescope: Search' })
    map('n', '<leader>sf', telescope.find_files, { desc = '[s]earch [f]iles' })
    map('n', '<leader>sh', telescope.help_tags, { desc = '[s]earch [h]elp' })
    map('n', '<leader>sw', telescope.grep_string, { desc = '[s]earch current [w]ord' })
    map('n', '<leader>sg', telescope.live_grep, { desc = '[s]earch by [g]rep' })
    map('n', '<leader>sd', telescope.diagnostics, { desc = '[s]earch [d]iagnostics' })
end

return {
    setup = setup
}
