return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    -- 'theHamsta/nvim-dap-virtual-text',
    'jay-babu/mason-nvim-dap.nvim',
  },
  ensure_installed = {},
  config = function()
    local dap = require 'dap'

    local dapui = require 'dapui'
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        'netcoredbg',
      },
    }
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    vim.keymap.set('n', '<leader>?', function()
      dapui.eval(nil, { enter = true })
    end)

    vim.keymap.set('n', '<leader>bt', dap.toggle_breakpoint)
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F6>', dap.step_over)
    vim.keymap.set('n', '<F7>', dap.step_out)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F10>', function()
      dap.terminate()
    end)

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dap_ui = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dap_ui = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dap_ui = function()
      dapui.close()
    end

    -- lua/configs/nvim-dap.lua
    -- ...
    -- local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/netcoredbg/netcoredbg'
    -- -- local explicit_path = "$HOME/Documents/debuggers/netcoredbg/netcoredbg"
    --
    -- local netcoredbg_adapter = {
    --   type = 'executable',
    --   command = mason_path,
    --   args = { '--interpreter=vscode' },
    -- }
    --
    -- dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
    -- dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

    -- lua/configs/nvim-dap.lua
    -- ...

    local dotnet = require 'my_dap.dap-dotnet'

    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return dotnet.build_dll_path()
        end,
      },
    }
  end,
}
