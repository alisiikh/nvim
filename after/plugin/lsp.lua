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
          map("v", "<leader>mt", [[<Esc><cmd>lua require("metals").type_of_range()<CR>]],
            { desc = 'metals: see type of range' })
          map("n", "<leader>mw", [[<cmd>lua require("metals").hover_worksheet({ border = "single" })<CR>]],
            { desc = 'metals: hover worksheet' })
          map("n", "<leader>mv", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]],
            { desc = 'metals: toggle tree view' })
          map("n", "<leader>mr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]],
            { desc = 'metals: reveal in tree' })
          map("n", "<leader>mi", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]],
            { desc = 'metals: show implicit args' })
          map("n", "<leader>mf", [[<cmd>lua require("metals").organize_imports()<CR>]],
            { desc = 'metals: organize imports' })
          map("n", "<leader>mg", [[<cmd>lua require("metals").goto_location()<CR>]], { desc = 'metals: goto location' })
          map("n", "<leader>md", [[<cmd>lua require("metals").implementation_location()<CR>]],
            { desc = 'metals: implementation location' })

          attach_lsp(bufnr)

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

          map("n", "<leader>dc", [[<cmd>lua require("dap").continue()<CR>]], { desc = 'dap: continue' })
          map("n", "<leader>dr", [[<cmd>lua require("dap").repl.toggle()<CR>]], { desc = 'dap: repl toggle' })
          map("n", "<leader>dK", [[<cmd>lua require("dap.ui.widgets").hover()<CR>]], { desc = 'dap: hover' })
          map("n", "<leader>dt", [[<cmd>lua require("dap").toggle_breakpoint()<CR>]], { desc = 'dap: toggle breakpoint' })
          map("n", "<leader>dso", [[<cmd>lua require("dap").step_over()<CR>]], { desc = 'dap: step over' })
          map("n", "<leader>dsi", [[<cmd>lua require("dap").step_into()<CR>]], { desc = 'dap: step into' })
          map("n", "<leader>drl", [[<cmd>lua require("dap").run_last()<CR>]], { desc = 'dap: run last' })

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
      vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
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

function attach_lsp(bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'lsp: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, 'lsp: [r]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, 'lsp: [c]ode [a]ction')

  nmap('gd', vim.lsp.buf.definition, 'lsp: [g]oto [d]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, 'lsp: [g]oto [r]eferences')
  nmap('gI', vim.lsp.buf.implementation, 'lsp: [g]oto [i]mplementation')
  nmap('<leader>td', vim.lsp.buf.type_definition, 'lsp: [t]ype [d]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'lsp: [d]ocument [s]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'lsp: [w]orkspace [s]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'lsp: hover documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'lsp: signature documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, 'lsp: [g]oto [d]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'lsp: [w]orkspace [a]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'lsp: [w]orkspace [r]emove Folder')
  nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    'lsp: [w]orkspace [l]ist folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'lsp: format code' })
end

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
      attach_lsp(bufnr)
    end

    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}
