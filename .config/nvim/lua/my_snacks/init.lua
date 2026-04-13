return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = {
      enabled = false,
      animate = {
        enabled = false,
      },
    },
    input = { enabled = true },
    picker = { enabled = true, layout = 'ivy' },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = 'Search Files',
    },
    {
      '<Leader>sg',
      function()
        Snacks.picker.grep()
      end,
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.buffer()
      end,
    },
    {
      '<leader>git',
      function()
        Snacks.lazygit()
      end,
    },
  },
}
