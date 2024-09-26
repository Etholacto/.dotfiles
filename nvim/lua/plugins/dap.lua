return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require("mason").setup()
    require('mason-nvim-dap').setup({
      automatic_installation = true,
      ensure_installed = {
        'cppdbg',
        'coreclr',
        'codelldb',
        'javadbg',
        'javatest',
        'js',
        'python',
      },
      handlers = {},
    })

    vim.fn.sign_define('DapBreakpoint', 
      { text = '', texthl = 'DiagnosticError', linehl = '', numhl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition',
      { text = '󰋗', texthl = 'DiagnosticError', linehl = '', numhl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointRejected',
      { text = '󰅙', texthl = 'Comment', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped',
      { text = '', texthl = 'DiagnosticOk', linehl = '', numhl ='DiagnosticOk' })

    local keymap = vim.keymap
    keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    keymap.set('n', '<F6>', function()
      dap.terminate()
      dap.close()
    end, { desc = 'Debug: End' })
    keymap.set('n', '<F7>', dap.step_into, { desc = 'Debug: Step Into' })
    keymap.set('n', '<F8>', dap.step_over, { desc = 'Debug: Step Over' })
    keymap.set('n', '<F9>', dap.step_out, { desc = 'Debug: Step Out' })
    keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close({})
    end

    --Godot config
    dap.adapters.godot = {
      type = 'server',
      host = '127.0.0.1',
      port = 6006,
    }

    dap.configurations.gdscript = {
      {
        type = 'godot',
        request = 'launch',
        name = 'Launch scene',
        project = '${workspaceFolder}',
        launch_scene = true
      }
    }
  end
}
