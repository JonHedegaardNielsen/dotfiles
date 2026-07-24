return {
  'L3MON4D3/LuaSnip',
  version = '2.*',
  build = function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end,
  dependencies = {
    {
      'rafamadriz/friendly-snippets',
      config = function()
        local luasnip = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()
        luasnip.filetype_extend('typescript', { 'tsdoc' })
        luasnip.filetype_extend('javascript', { 'jsdoc' })
        luasnip.filetype_extend('lua', { 'luadoc' })
        luasnip.filetype_extend('cs', { 'csharpdoc' })
        luasnip.filetype_extend('gd', { 'godotdoc' })
      end,
    },
  },
  opts = {},
  config = function()
    local luasnip = require 'luasnip'
    vim.keymap.set({ 'i', 's' }, '<C-L>', function()
      luasnip.jump(1)
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-H>', function()
      luasnip.jump(-1)
    end, { silent = true })
  end,
}
