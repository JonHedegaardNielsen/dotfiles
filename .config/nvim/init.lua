require 'variables'()
require 'keymaps'()
vim.pack.add {
  'https://codeberg.org/ziglang/zig.vim',
}

-- don't show parse errors in a separate window
vim.g.zig_fmt_parse_errors = 1
-- enable  format-on-save from vim.lsp + ZLS
vim.g.build_on_save = 1
-- Terminal colors
vim.o.termguicolors = true
-- Formatting with ZLS matches `zig fmt`.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.zig', '*.zon' },
  callback = function(ev)
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.zig', '*.zon' },
  callback = function(ev)
    vim.lsp.buf.code_action {
      context = { only = { 'source.fixAll' } },
      apply = true,
    }
  end,
})

vim.lsp.config['zls'] = {
  -- Set to 'zls' if `zls` is in your PATH
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig' },
  -- There are two ways to set config options:
  --   - edit your `zls.json` that applies to any editor that uses ZLS
  --   - set in-editor config options with the `settings` field below.
  --
  -- Further information on how to configure ZLS:
  -- https://zigtools.org/zls/configure/
  settings = {
    zls = {
      -- Whether to enable build-on-save diagnostics
      --
      -- Further information about build-on save:
      -- https://zigtools.org/zls/guides/build-on-save/
      -- enable_build_on_save = true,

      -- omit the following line if `zig` is in your PATH
    },
  },
}
vim.lsp.enable 'zls'
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
vim.api.nvim_create_autocmd('ModeChanged', {
  command = 'LuaSnipUnlinkCurrent',
  desc = "Close code snippet editing after insert mode exit, so <Tab> won't unexpectedly jump back to it",
  pattern = 'i:*',
})

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
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {}
    end,
  },
  require 'my_neo_tree',
  require 'my_gitsigns',
  require 'my_trouble',
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        mapping = {
          ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<C-e>'] = cmp.mapping.abort(), -- Close completion menu
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Confirm selected item
        },
      }
    end,
  },
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
