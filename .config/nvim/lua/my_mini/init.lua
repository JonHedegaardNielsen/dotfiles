return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    require('mini.pairs').setup {
      mappings = {
        ['('] = false,
        [')'] = false,
        ['['] = false,
        [']'] = false,
        ['{'] = false,
        ['}'] = false,
        ['"'] = false,
        ["'"] = false,
        ['`'] = false,
      },
    }

    MiniPairs.map('i', '<M-(>', { action = 'open', pair = '()', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-)>', { action = 'close', pair = '()', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-[>', { action = 'open', pair = '[]', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-]>', { action = 'close', pair = '[]', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-{>', { action = 'open', pair = '{}', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-}>', { action = 'close', pair = '{}', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-<>', { action = 'open', pair = '<>', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M->>', { action = 'close', pair = '<>', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', '<M-">', { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].' })
    MiniPairs.map('i', "<M-'>", { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].' })
    MiniPairs.map('i', '<M-`>', { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].' }) -- Now map Alt+key to trigger the pair behavior

    require('mini.move').setup {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = 'H',
        right = 'L',
        down = 'J',
        up = 'K',

        -- Move current line in Normal mode
        line_left = '',
        line_right = '',
        line_down = '',
        line_up = '',
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    }
  end,
}
