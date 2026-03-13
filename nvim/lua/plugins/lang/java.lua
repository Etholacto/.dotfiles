return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	opts = function()
		local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

		local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1])

		return {
			root_dir = root_dir,

			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,

			jdtls_config_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
			end,

			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,

			full_cmd = function(opts)
				local cmd = { vim.fn.exepath("jdtls") }

				if vim.uv.fs_stat(lombok_jar) then
					table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
				end

				local root_dir = opts.root_dir
				local project_name = opts.project_name(root_dir)

				if project_name then
					vim.list_extend(cmd, {
						"-configuration",
						opts.jdtls_config_dir(project_name),
						"-data",
						opts.jdtls_workspace_dir(project_name),
					})
				end

				return cmd
			end,

			dap = { hotcodereplace = "auto", config_overrides = {} },
			test = false,
			settings = {
				java = {
					inlayHints = {
						parameterNames = {
							enabled = "all",
						},
					},
				},
			},
		}
	end,

	config = function(_, opts)
		local mason_registry = require("mason-registry")
		local bundles = {} ---@type string[]

		local function extend_bundles(patterns)
			for _, pattern in ipairs(patterns) do
				local matches = vim.fn.glob(pattern, true, true)
				for _, bundle in ipairs(matches) do
					table.insert(bundles, bundle)
				end
			end
		end

		if opts.dap and mason_registry.is_installed("java-debug-adapter") then
			extend_bundles({
				vim.fn.expand("$MASON/packages/java-debug-adapter/extension/server/*.jar"),
			})

			if opts.test and mason_registry.is_installed("java-test") then
				extend_bundles({
					vim.fn.expand("$MASON/packages/java-test/extension/server/*.jar"),
				})
			end
		end

		local function attach_jdtls()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

			local config = {
				cmd = opts.full_cmd(opts),
				root_dir = opts.root_dir,
				init_options = {
					bundles = bundles,
				},
				settings = opts.settings,
				capabilities = capabilities,
			}

			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = attach_jdtls,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					if opts.dap and mason_registry.is_installed("java-debug-adapter") then
						require("jdtls").setup_dap(opts.dap)
						require("jdtls.dap").setup_dap_main_class_configs()
					end
				end
			end,
		})
	end,
}
