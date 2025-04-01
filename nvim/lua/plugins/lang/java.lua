return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	opts = function()
		local cmd = { vim.fn.exepath("jdtls") }
		local mason_registry = require("mason-registry")
		local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
		table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
		return {
			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),

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
		local bundles = {} ---@type string[]
		local mason_registry = require("mason-registry")
		if opts.dap and mason_registry.is_installed("java-debug-adapter") then
			local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
			local java_dbg_path = java_dbg_pkg:get_install_path()
			local jar_patterns = {
				java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
			}
			if opts.test and mason_registry.is_installed("java-test") then
				local java_test_pkg = mason_registry.get_package("java-test")
				local java_test_path = java_test_pkg:get_install_path()
				vim.list_extend(jar_patterns, {
					java_test_path .. "/extension/server/*.jar",
				})
			end
			for _, jar_pattern in ipairs(jar_patterns) do
				for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
					table.insert(bundles, bundle)
				end
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
					end
				end
			end,
		})

		attach_jdtls()
	end,
}
