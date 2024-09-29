return {
    {
        "catppuccin/nvim",
        priority = 1000,
        config = require("plugins.conf.catppuccin"),
    },

    {
        "nvim-treesitter/nvim-treesitter",
        priority = 500,
        build = ":TSUpdate",
        config = require("plugins.conf.treesitter"),
    },

    {
        "hrsh7th/nvim-cmp",
        priority = 300,
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
            "chrisgrieser/cmp-nerdfont",
        },
        -- Currently configured by the nvim_lspconfig  config
        -- config = require("plugins.conf.nvim_cmp"),
    },

    {
        "neovim/nvim-lspconfig",
        priority = 100,
        dependencies = {
            "folke/neodev.nvim",
            "weilbith/nvim-code-action-menu",
        },
        config = require("plugins.conf.nvim_lspconfig")
    },

    {
        "nvim-lualine/lualine.nvim",
        config = require("plugins.conf.lualine"),
    },

    {
        "akinsho/bufferline.nvim",
        branch = "main",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = require("plugins.conf.bufferline"),
    },

    {
        "windwp/nvim-autopairs",
        config = require("plugins.conf.autopairs")
    },

    {
        "nvim-tree/nvim-tree.lua",
        config = require("plugins.conf.nvim_tree"),
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
        "folke/which-key.nvim",
        config = function()
            local which_key = require("which-key")
            which_key.setup({})
        end,
    },

    {
        "folke/zen-mode.nvim",
        config = require("plugins.conf.zen_mode"),
    },

    {
        "gbprod/yanky.nvim",
        config = require("plugins.conf.yanky"),
    },

    {
        "numToStr/Comment.nvim",
        config = require("plugins.conf.comments"),
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = require("plugins.conf.todo_comments"),
    },

    {
        "kkoomen/vim-doge",
        config = require("plugins.conf.vim_doge"),
    },

    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {},
    },

    {
        "jannis-baum/vivify.vim"
    },
}
