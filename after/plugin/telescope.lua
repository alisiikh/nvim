local function map(n, keys, cmd, opts)
	vim.keymap.set(n, keys, cmd, opts)
end

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

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
map('n', '<leader>sf', telescope.git_files, { desc = '[s]earch [f]iles' })
map('n', '<leader>sp', telescope.find_files, { desc = '[s]earch all files' })
map('n', '<leader>sh', telescope.help_tags, { desc = '[s]earch [h]elp' })
map('n', '<leader>sw', telescope.grep_string, { desc = '[s]earch current [w]ord' })
map('n', '<leader>sg', telescope.live_grep, { desc = '[s]earch by [g]rep' })
map('n', '<leader>sd', telescope.diagnostics, { desc = '[s]earch [d]iagnostics' })


