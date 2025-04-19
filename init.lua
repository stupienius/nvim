-- general setting
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- autocmd for c/c++ file to set 4-space tab
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

-- lazy.vim for manage vim plugin
vim.opt.rtp:prepend("~/.config/nvim/lazy/lazy.nvim")

require("lazy").setup({

	-- nvim-tree for file tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- nvim-web-devicons for file icons
		config = function()
			require("nvim-tree").setup({})
		end,
	},

	-- null-ls for auto formatting
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- Example formatters:
					null_ls.builtins.formatting.prettier, -- JS/TS/HTML/CSS
					null_ls.builtins.formatting.stylua, -- Lua
					null_ls.builtins.formatting.black, -- Python
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
})

-- keymaps
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
