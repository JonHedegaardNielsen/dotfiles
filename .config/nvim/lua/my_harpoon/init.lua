return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon [A]dd' })
    vim.keymap.set('n', '<leader>hm', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [M]enu' })

    vim.keymap.set('n', '<leader>l1', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<leader>l2', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<leader>l3', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<leader>l4', function()
      harpoon:list():select(4)
    end)
  end,
}
