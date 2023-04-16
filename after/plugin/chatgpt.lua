local gpt = require('chatgpt')

gpt.setup({
  chat = {
    keymaps = {
      close = "<Esc>",
      yank_last = "<C-y>",
      scroll_up = "<C-u>",
      scroll_down = "<C-d>",
      toggle_settings = "<C-o>",
      new_session = "<C-n>",
      cycle_windows = "<Tab>",
    },
  },
  popup_input = {
    submit = { "<C-s>", "<C-Enter>" },
  },
})

local function map(mode, lhs, rhs, desc)
  if (desc) then
    desc = "gpt: " .. desc
  end

  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

map('n', '<leader>gg', gpt.openChat, 'open chat')
map('v', '<leader>ge', gpt.edit_with_instructions, 'edit with instructions')
map('n', '<leader>ga', gpt.selectAwesomePrompt, 'act as')
