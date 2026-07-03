return {
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
}
