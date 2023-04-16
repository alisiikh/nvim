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


local function nmap(lhs, rhs, desc)
  if (desc) then
    desc = "gpt: " .. desc
  end

  vim.keymap.set('n', lhs, rhs, { desc = desc, silent = true })
end

nmap('<leader>gg', ':ChatGPT<CR>', 'open prompt')
