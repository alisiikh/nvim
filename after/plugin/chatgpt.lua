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


local wk = require('which-key')

wk.register({
  g = {
    name = 'gpt',
    g = { gpt.openChat, "gpt: open chat" },
    e = { gpt.edit_with_instructions, "gpt: edit with instructions" },
    a = { gpt.selectAwesomePrompt, "gpt: act as" },
  },
}, { prefix = '<leader>' })
