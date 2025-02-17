return {
	'mfussenegger/nvim-dap',
	dependencies = {
		{
			'rcarriga/nvim-dap-ui',
			dependencies = {
				'nvim-neotest/nvim-nio',
			}
		},
		{
			'theHamsta/nvim-dap-virtual-text',
			opts = {
				commented = true,
				virt_text_pos = 'eol',
			},
		},
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
				'coreclr',
				'cpptools',
				'javadbg',
				'javatest',
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
			{ text = '', texthl = 'DiagnosticOk', linehl = '', numhl = 'DiagnosticOk' })

		local keymap = vim.keymap
		keymap.set('n', '<F5>', dap.continue, { desc = 'Start/Continue' })
		keymap.set('n', '<F6>', function()
			dap.terminate()
			dap.close()
		end, { desc = 'End' })
		keymap.set('n', '<F7>', dap.step_into, { desc = 'Step Into' })
		keymap.set('n', '<F8>', dap.step_over, { desc = 'Step Over' })
		keymap.set('n', '<F9>', dap.step_out, { desc = 'Step Out' })
		keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
		keymap.set('n', '<leader>dB', function()
			dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end, { desc = 'Set Breakpoint' })

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

		--Java config
		dap.configurations.java = {
			{
				type = 'java',
				name = 'Debug (Attach)',
				request = 'attach',
				hostName = '127.0.0.1',
				port = 5005,
			},
		}
	end
}
