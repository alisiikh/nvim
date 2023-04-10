local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
      options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- [[ Scala metals ]]
-- See `:help metals`???
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback =
      function()
        local metals_config = require("metals").bare_config()
        metals_config.tvp = {
          icons = {
            enabled = true
          }
        }
        metals_config.settings = {
          showImplicitArguments = true,
          showImplicitConversionsAndClasses = true,
          showInferredType = true,
          excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl",
            "akka.stream.javadsl",
            "akka.http.javadsl",
          },
          fallbackScalaVersion = "2.13.8",
          serverVersion = "latest.snapshot",
        }

        metals_config.init_options.statusBarProvider = "on"
        metals_config.capabilities = capabilities

        metals_config.on_attach = function(client, bufnr)
          -- Metals specific mappings
          map("v", "K", [[<Esc><cmd>lua require("metals").type_of_range()<CR>]])
          map("n", "<leader>ws", [[<cmd>lua require("metals").hover_worksheet({ border = "single" })<CR>]])
          map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
          map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
          map("n", "<leader>st", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])

          vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = lsp_group,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = lsp_group,
          })
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            callback = vim.lsp.codelens.refresh,
            buffer = bufnr,
            group = lsp_group,
          })
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dap-repl" },
            callback = function()
              require("dap.ext.autocompl").attach()
            end,
            group = lsp_group,
          })

          -- nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "Run or test with input",
              metals = {
                runType = "runOrTestFile",
                args = function()
                  local args_string = vim.fn.input("Arguments: ")
                  return vim.split(args_string, " +")
                end,
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Run or Test",
              metals = {
                runType = "runOrTestFile",
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }

          map("n", "<leader>dc", [[<cmd>lua require("dap").continue()<CR>]])
          map("n", "<leader>dr", [[<cmd>lua require("dap").repl.toggle()<CR>]])
          map("n", "<leader>dK", [[<cmd>lua require("dap.ui.widgets").hover()<CR>]])
          map("n", "<leader>dt", [[<cmd>lua require("dap").toggle_breakpoint()<CR>]])
          map("n", "<leader>dso", [[<cmd>lua require("dap").step_over()<CR>]])
          map("n", "<leader>dsi", [[<cmd>lua require("dap").step_into()<CR>]])
          map("n", "<leader>drl", [[<cmd>lua require("dap").run_last()<CR>]])

          dap.listeners.after["event_terminated"]["nvim-metals"] = function(session, body)
            dap.repl.open()
          end

          require("metals").setup_dap()
        end

        require("metals").initialize_or_attach(metals_config)
      end,
  group = nvim_metals_group,
})


local rt = require('rust-tools')
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  }
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    -- LSP settings.
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'lsp: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

      nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
      nmap('gI', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'type [d]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'hover documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'signature documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[g]oto [d]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
      nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[w]orkspace [l]ist folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'format current buffer with' })
    end

    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}