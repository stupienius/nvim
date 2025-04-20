-------------
-- general --
-------------

vim.g.mapleader = " " -- use <space> as leader key
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2 -- 2-space tab
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus" -- use system clipboard as nvim clipboard
vim.opt.pumheight = 8 -- popup up menu max items

--vim.opt.termguicolors = true

-- autocmd for c/c++ file to set 4-space tab
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

------------
-- plugin --
------------

-- lazy.vim for manage vim plugin
vim.opt.rtp:prepend("~/.config/nvim/lazy/lazy.nvim")

require("lazy").setup({

	-- gruvbox for theme
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = true,
					folds = true,
				},
				transparent_mode = true,
			})
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	-- welcome dashboard
	{
		"goolord/alpha-nvim",
		-- dependencies = { 'echasnovski/mini.icons' },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local startify = require("alpha.themes.startify")
			-- available: devicons, mini, default is mini
			-- if provider not loaded and enabled is true, it will try to use another provider

			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			vim.cmd([[highlight AlphaHeader guifg=#7aa2f7 gui=bold]])
			startify.file_icons.provider = "devicons"

			dashboard.config.layout = {
				{ type = "padding", val = 2 },
				{
					type = "text",
					val = {
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢵⡦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⣺⠕⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠺⣷⢤⡀⠀⠀⠀⠀⠀⢂⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⣞⠝⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣄⡀⠀⠀⠑⢿⡢⣄⠀⠀⠀⡀⠑⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⢖⡯⠊⠁⠀⠀⠀⣀⣤⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⢿⣿⣿⢿⣿⣿⣦⡀⠀⠀⠉⠺⣷⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢶⣫⠗⠉⠀⠀⠀⠀⣰⣿⣿⡿⣿⣿⣝⡷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠍⡯⡟⠉⢈⠿⢿⣿⡇⠀⠀⠀⠀⠈⠳⢽⡷⣄⠀⠀⠀⣠⡴⣻⠵⠋⠀⠀⠀⠀⠀⠀⠀⣿⠿⠿⡈⠛⠭⡛⢙⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣒⡲⢄⠀⠀⠀⠠⠀⢉⠙⠿⠄⡴⠌⠀⠀⠀⠀⠀⠀⠀⠀⠙⠮⣿⢦⡛⠽⠛⠁⠀⠀⠐⠈⠀⠀⠀⠀⠀⠰⢦⢤⠷⠊⠩⠀⠈⠀⠀⠀⢀⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣜⡿⠗⠃⠑⣌⠔⠨⠀⠻⡇⠠⠸⡷⠁⠀⠀⢀⠀⠀⠀⠀⢀⣤⢖⡈⠳⢽⡷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣚⡦⠂⣸⡇⠐⠡⡑⠈⠕⣩⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⠀⡀⢠⡈⢦⣈⠓⡆⢀⣀⠙⠷⠗⠀⠀⠀⠀⠑⢦⢀⣠⠶⣫⠶⠋⠀⠀⠀⠙⢮⣛⢦⣀⠀⣸⠃⠀⠀⠀⠀⠀⠀⣴⠞⠁⠀⢄⡀⡠⢂⠀⣿⠟⠁⠻⢢⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠞⠁⠀⠄⣃⠹⣄⠛⠦⣌⣉⣿⠧⠀⠀⡐⠀⠀⠀⠀⠀⢄⢊⠳⡕⠛⠁⠀⠀⠀⠀⠀⠀⠀⠈⠳⣩⢞⠥⡄⠀⠀⠀⠀⠀⠀⠀⢀⡢⠀⠀⣲⡖⠉⣜⠏⣠⠀⡄⢠⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠾⠡⠥⣄⣀⠠⠣⠙⢦⣈⠓⠲⢔⣲⡟⢉⠅⠀⠃⡀⠀⠀⡀⢣⠣⣣⠣⠘⢦⡀⠀⠈⠀⠀⢠⠀⠀⣠⠞⠁⠢⡪⠣⢀⠀⠀⠀⠀⠀⠀⣜⠁⠀⢐⠒⢇⣾⠂⢘⣡⠞⣠⠇⡜⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠉⠁⠀⠀⠈⠉⠉⠉⠈⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠁⠡⠣⠡⡁⠠⣀⠀⠀⠀⠀⠀⠀⠁⡜⠃⠈⠉⠀⠜⠁⡸⢁⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡀⠄⠀⠀⠃⠀⠿⠉⠁⠒⠂⠠⠰⡐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠐⠀⠀⠙⠀⠘⠀⡐⠀⣤⢊⡟⠐⠀⠀⠒⠆⠈⠀⢂⠌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⡀⡐⠀⠀⠀⠀⠀⠁⢉⠅⠣⠓⠁⠠⡆⡑⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣴⠄⠀⠀⠉⠙⠻⠌⠁⠀⠃⠀⠀⢀⠠⡀⡉⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠮⠋⠳⠄⢠⠐⠀⠀⠠⡀⠀⠀⠀⠀⠀⠀⠀⠐⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠂⠂⠀⢍⡣⢠⠞⠁⢐⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢪⣩⡟⠈⠀⠂⠴⡠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠙⢦⢤⠀⠌⠀⣸⠮⠁⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣰⡌⡷⢤⣄⠠⠎⠈⢘⡒⢤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⠤⡶⠲⠏⠭⠀⠀⠷⠤⡤⠒⠃⠾⣧⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⠇⠀⠦⠰⠃⠀⠀⠀⠀⠀⠈⠉⠓⠻⠶⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⢴⠶⠟⠛⠁⠉⠀⠀⠀⠀⠀⠀⠀⠀⠒⠈⠂⠀⠀⣟⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠛⡿⣯⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣁⠿⢏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣌⣁⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢹⣭⠠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⣴⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢧⡙⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⡀⡴⠿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⣣⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣌⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⡆⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⢴⠃⡃⣶⠤⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢎⡴⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣢⠃⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⡤⡅⣣⡒⢄⠀⠀⠀⠀",
						"⢀⡤⢞⣡⠒⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡱⡟⠁⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠈⢲⠉⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠙⠠⡕⠤⠀⠀",
						"⠈⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠒⡨⡦⡀⡀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠄⠀⠀⠀⠀⠀⠀⠠⠀⠀⠐⠐⠀⠀⠀⠀⠀⣀⢠⢄⡰⠲⠉⣴⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⡀⠀⢀⠀⠀⠈⠈⠀⠀⠈⠐⠵⢂⣴⠀⠀⢀⣂⠁⠠⠤⠐⠀⢀⣂⢚⡡⡑⠉⣍⡤⠤⠀⠀⣀⣀⡀⠈⠓⡀⠁⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂⠂⠀⠀⠀⠀⠀⠀⠁⠐⠂⠒⠒⠲⠤⠴⠶⠰⠮⠍⠠⠄⣀⡢⠀⠴⠫⠍⠁⣠⣠⢄⢀⡀⠉⠁⠢⠤⠤⠒⠈⣂⠂⠂⠀⠠⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
					},
					opts = {
						position = "center",
						hl = "AlphaHeader",
					},
				},
				{ type = "padding", val = 1 },
				dashboard.section.buttons,
				{ type = "padding", val = 1 },
				dashboard.section.footer,
			}

			dashboard.section.buttons.val = {
				dashboard.button("n", "📁  New file", ":ene <BAR> startinsert<CR>"),
				dashboard.button("f", "🔍  Find file", ":Telescope find_files<CR>"),
				dashboard.button("r", "⏰  Recent files", ":Telescope oldfiles<CR>"),
				dashboard.button("c", "⚙️   Config", ":e $HOME/.config/nvim/init.lua<CR>"),
				dashboard.button("l", "📦  Lazy", ":Lazy<CR>"),
				dashboard.button("q", "👋  Quit", ":qa<CR>"),
			}
			dashboard.section.footer.val = "🧠 Happy hacking!"
			alpha.setup(dashboard.config)
		end,
	},

	-- telescope.nvim for find file
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					prompt_prefix = "   ",
					selection_caret = " ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",

					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.85,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},

					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist",
						"build",
						"%.lock",
						"%.DS_Store",
					},

					winblend = 15, -- slight transparency
					border = true,

					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<esc>"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						theme = "ivy",
					},
					live_grep = {
						theme = "ivy",
					},
				},
			})
		end,
	},

	-- gitsigns for signs
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({})
		end,
	},

	-- nvim-highlight-colors for highlight color
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				enable_hex = true,
				enable_short_hex = true,
				enable_rgb = true,
				enable_hsl = true,
				enable_var_usage = true,
				enable_named_colors = true,
				enable_tailwind = true,
			})
		end,
		event = { "BufReadPre", "BufNewFile" },
	},

	-- auto pair
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- enable treesitter integration
				fast_wrap = {}, -- optional: fast wrapping feature
			})
		end,
	},

	-- nvim-tree for file tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- nvim-web-devicons for file icons
		config = function()
			require("nvim-tree").setup({
				filters = {
					dotfiles = true,
				},
			})
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

	-- bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({})
		end,
	},

	-- nvim-treesitter for idw
	{
		"nvim-treesitter/nvim-treesitter",
		version = "0.9.3",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"html",
					"javascript",
					"typescript",
					"tsx",
					"lua",
					"c",
					"cpp",
					"json",
					"css",
				},
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true }, -- for nvim-ts-autotag
			})
		end,
	},

	-- nvim-ts-autotag for html auto tag
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- nvim-cmp for auto completion
	{
		"neovim/nvim-lspconfig",
		commit = "cb33dea", -- Last commit compatible with Neovim 0.9.5
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.ts_ls.setup({ -- TS JS
				capabilities = capabilities,
			})

			lspconfig.clangd.setup({ -- c/c++
				capabilities = capabilities,
			})

			lspconfig.pyright.setup({ -- python
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({ -- tailwindcss
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
				init_options = {
					userLanguages = {
						eelixir = "html",
						eruby = "html",
					},
				},
			})
		end,
	},
	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").setup({
				mode = "symbol_text",
				preset = "codicons",

				symbol_map = {
					Text = "󰉿",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "",
				},
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.setup({
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
					},
					documentation = {
						border = "rounded",
					},
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = function(entry, item)
						local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
						item = require("lspkind").cmp_format({
							ellipsis_char = "...", -- when popup menu exceed maxwis_char instead (must define maxwidth first)
							show_labelDetails = true, -- show labelDetails in menu. Disabled by default
						})(entry, item)
						if color_item.abbr_hl_group then
							item.kind_hl_group = color_item.abbr_hl_group
							item.kind = color_item.abbr
						end
						return item
					end,
				},
			})
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
})
-------------
-- keymaps --
-------------

-- filetree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- buffer
vim.keymap.set("n", "H", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "L", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true })

-- telescope
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", {})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {})
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {})
