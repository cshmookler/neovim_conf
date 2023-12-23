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
                "hrsh7th/cmp-nvim-lsp-document-symbol",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-calc",
                "uga-rosa/cmp-dictionary",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "rafamadriz/friendly-snippets",
                "hrsh7th/cmp-emoji",
                "folke/neodev.nvim",
                { "j-hui/fidget.nvim", tag = "legacy" },
                "mfussenegger/nvim-jdtls",
                "weilbith/nvim-code-action-menu",
                "kosayoda/nvim-lightbulb",
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
            "airblade/vim-gitgutter",
        },

        {
            "dstein64/vim-startuptime",
            config = function()
                require("startuptime")
            end,
        },

        {
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            ft = { "markdown" },
            build = function() vim.fn["mkdp#util#install"]() end,
        },

        {
            "max397574/better-escape.nvim",
            config = require("plugin.better-escape"),
        },

        {
            "folke/which-key.nvim",
            config = function()
                local which_key = require("which-key")
                which_key.setup({})
            end,
        },

        {
            "nvim-treesitter/nvim-treesitter",
            dependencies = {
                "nvim-treesitter/nvim-treesitter-textobjects",
            },
            build = "TSUpdate",
            config = require("plugin.treesitter"),
        },

        {
            "ThePrimeagen/refactoring.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
            },
            config = require("plugin.refactoring"),
        },

        {
            "folke/zen-mode.nvim",
            config = require("plugin.zen"),
        },

        {
            "gbprod/yanky.nvim",
            config = require("plugin.yanky"),
        },

        {
            "tpope/vim-eunuch",
        },

    })
end
