return function()
    local lazy = require("lazy")
    lazy.setup({

        {
            "catppuccin/nvim",
            priority = 1000,
            config = require("plugin.catppuccin"),
        },

        {
            "hrsh7th/nvim-cmp",
            priority = 100,
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-calc",
                "hrsh7th/cmp-nvim-lsp-document-symbol",
                "SirVer/ultisnips",
                "quangnguyen30192/cmp-nvim-ultisnips"
            },
            config = require("plugin.cmp"),
        },

        {
            "nvim-lualine/lualine.nvim",
            config = require("plugin.lualine"),
        },

        {
            "akinsho/bufferline.nvim",
            config = require("plugin.bufferline"),
        },

        {
            "numToStr/Comment.nvim",
            config = require("plugin.comment")
        },

        {
            "windwp/nvim-autopairs",
            config = require("plugin.autopairs")
        },

        {
            "lukas-reineke/indent-blankline.nvim",
            config = require("plugin.indent-blankline")
        },

        {
            "nvim-tree/nvim-tree.lua",
            config = require("plugin.tree"),
        },

        {
            "airblade/vim-gitgutter"
        },

    })
end
