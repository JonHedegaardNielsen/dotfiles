return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		build = ":NeoTree",
		lazy = false, -- neo-tree will lazily load itself
		config = function()
			vim.keymap.set('n', '<leader>nc', ':Neotree close<CR>')
			vim.keymap.set('n', '<leader>no', ':Neotree<CR>')
		end
	}
}
