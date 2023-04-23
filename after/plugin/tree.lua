local tree = require('nvim-tree')
local api = require('nvim-tree.api')

tree.setup {
  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
  end
}

local nmap = require('helpers').nmap

nmap('<leader>o', api.tree.toggle, { desc = 'nvim-tree: toggle', noremap = true })
