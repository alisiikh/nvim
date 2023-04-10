local nvm_tree = require('nvim-tree')
nvm_tree.setup {
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    -- TODO: add keymaps for nvim-tree
  end
}

