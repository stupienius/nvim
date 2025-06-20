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
vim.opt.background = "dark"
vim.opt.scrolloff = 6
vim.opt.cursorline = true

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
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("Comment").setup()
		end,
	},
	"tpope/vim-commentary",
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

	-- terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 9, -- height of terminal split
				open_mapping = [[<C-\>]], -- toggle key
				shade_terminals = true,
				shading_factor = 2,
				direction = "horizontal", -- bottom like VSCode
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = true,
				close_on_exit = true,
				shell = vim.o.shell, -- default to your shell (bash/zsh/fish/etc.)
			})
		end,
		keys = {
			{ "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
		},
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Eviline config for lualine
			-- Author: shadmansaleh
			-- Credit: glepnir
			local lualine = require("lualine")

			local colors = {
				bg = "#202328",
				fg = "#bbc2cf",
				yellow = "#ECBE7B",
				cyan = "#008080",
				darkblue = "#081633",
				green = "#98be65",
				orange = "#FF8800",
				violet = "#a9a1e1",
				magenta = "#c678dd",
				blue = "#51afef",
				red = "#ec5f67",
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			-- Config
			local config = {
				options = {
					-- Disable sections and component separators
					component_separators = "",
					section_separators = "",
					theme = {
						-- We are going to use lualine_c an lualine_x as left and
						-- right section. Both are highlighted by c theme .  So we
						-- are just setting default looks o statusline
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
				},
				sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					-- These will be filled later
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			-- Inserts a component in lualine_x at right section
			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left({
				function()
					return "▊"
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don't need space before this
			})

			ins_left({
				-- mode component
				function()
					return ""
				end,
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						[""] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			})

			ins_left({
				-- filesize component
				"filesize",
				cond = conditions.buffer_not_empty,
			})

			ins_left({
				"filename",
				cond = conditions.buffer_not_empty,
				color = { fg = colors.magenta, gui = "bold" },
			})

			ins_left({ "location" })

			ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

			ins_left({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			})

			-- Insert mid section. You can make any number of sections in neovim :)
			-- for lualine it's any number greater then 2
			ins_left({
				function()
					return "%="
				end,
			})

			ins_left({
				-- Lsp server name .
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
					local clients = vim.lsp.get_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = " LSP:",
				color = { fg = "#ffffff", gui = "bold" },
			})

			-- Add components to right sections
			ins_right({
				"o:encoding", -- option component same as &encoding in viml
				fmt = string.upper, -- I'm not sure why it's upper case either ;)
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"fileformat",
				fmt = string.upper,
				icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"branch",
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			})

			ins_right({
				"diff",
				-- Is it me or the symbol for modified us really weird
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			})

			ins_right({
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			})

			-- Now don't forget to initialize lualine
			lualine.setup(config)
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
					path_display = { "smart" },
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
							preview_width = 0.55,
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
					null_ls.builtins.formatting.clang_format.with({
						filetypes = { "c", "cpp", "objc", "objcpp" },
					}),
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
					"vue",
				},
				highlight = { enable = false },
				indent = { enable = true },
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
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
				capabilities = capabilities,
			})

			lspconfig.clangd.setup({ -- c/c++
				capabilities = capabilities,
			})

			lspconfig.pyright.setup({ -- python
				capabilities = capabilities,
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
			})

			lspconfig.emmet_ls.setup({
				filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
				capabilities = capabilities,
			})

			lspconfig.volar.setup({
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
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
vim.keymap.set("n", "L", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "H", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true })

-- telescope
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", {})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {})
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {})

-- split window
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>sq", ":only<CR>", { desc = "quite the window split" })

-- Navigate
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")

-- window size
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Shrink window height" })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Shrink window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Increase window width" })

-- Terminal mode keymaps
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		local opts = { buffer = 0 }

		-- Press Esc twice to leave terminal mode
		vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)

		-- Use <C-h/j/k/l> to navigate splits from terminal
		vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
		vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
		vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
		vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)

		-- Hide terminal with <C-q>
		vim.keymap.set("t", "<leader>t", [[<C-\><C-n>:hide<CR>]], opts)
	end,
})
