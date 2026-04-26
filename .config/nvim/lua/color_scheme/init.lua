return {
  'tiagovla/tokyodark.nvim',
  opts = {
    -- custom options here
  },
  config = function(_, opts)
    require('tokyodark').setup(opts) -- calling setup is optional
    local groups = {
      'Normal',
      'NormalNC',
      -- 'Comment',
      -- 'Constant',
      -- 'Special',
      -- 'Identifier',
      -- 'Statement',
      'PreProc',
      -- 'Type',
      -- 'Underlined',
      -- 'Todo',
      -- 'String',
      -- 'Function',
      -- 'Conditional',
      'Repeat',
      -- 'Operator',
      -- 'Structure',
      'LineNr',
      'NonText',
      'SignColumn',
      'CursorLine',
      'CursorLineNr',
      'StatusLine',
      'StatusLineNC',
      'EndOfBuffer',
    }
    vim.cmd [[colorscheme tokyodark]]
    for i, v in ipairs(groups) do
      vim.api.nvim_set_hl(0, v, { bg = '' })
    end
    -- vim.api.nvim_set_hl(0, 'Normal', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'Pmenu', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'LineNr', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'TabLine', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'NonText', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'StatusLine', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '' })
    -- vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = '' })
    vim.o.background = 'dark'
  end,
}
