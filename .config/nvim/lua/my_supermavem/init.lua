return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<A-y>',
        clear_suggestion = '<A-C>',
        accept_word = '<A-w>',
      },
    }
  end,
}
