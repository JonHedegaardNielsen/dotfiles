require 'variables'
require 'keymaps'
require 'my_zig'
require 'auto_commands'
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@type vim.Option

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  require 'my_guess-indent',
  require 'my_neo_tree',
  require 'my_gitsigns',
  require 'my_trouble',
  require 'my_nvim-cmp',
  require 'my_dap.init',
  require 'my_snacks',
  require 'my_neotest',
  require 'my_which-key',
  require 'my_rust',
  require 'my_lualine',
  require 'my_supermavem',
  require 'my_telescope.init',
  require 'my_oil',
  { 'kevinhwang91/promise-async' },
  require 'color_scheme',
  require 'my_harpoon.init',
  require 'my_lazydev',
  require 'LSP.init',
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = false,
  },
  require 'my_conform',
  require 'my_blink-cmp',
  require 'my_todo-comments.init',
  require 'my_mini',
  require 'my_treesitter',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
