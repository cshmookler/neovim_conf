return function(languages, lsp_servers, icons_enabled)
    return {

        {
            "navarasu/onedark.nvim",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("onedark")
            end,
        },

        {
            "nvim-treesitter/nvim-treesitter",
            priority = 100,
            dependencies = {
                "nvim-treesitter/nvim-treesitter-textobjects",
            },
            build = ":TSUpdate",
            config = function()
                local treesitter = require("nvim-treesitter.configs")
                treesitter.setup(require("opt.treesitter")(languages))
                -- treesitter.setup(require("opt.treesitter"))
                vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
                    desc = 'Go to previous diagnostic message' })
                vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
                    desc = 'Go to next diagnostic message' })
                vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {
                    desc = 'Open floating diagnostic message' })
                vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
                    desc = 'Open diagnostics list' })
            end,
        },

        {
            "neovim/nvim-lspconfig",
            priority = 99,
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                {
                    "j-hui/fidget.nvim",
                    tag = "legacy",
                    event = "LspAttach",
                    config = function()
                        local fidget = require("fidget")
                        fidget.setup()
                    end,
                },

                "folke/neodev.nvim",

                "hrsh7th/nvim-cmp",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer", -- Consider removing this entirely.
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",

                "mfussenegger/nvim-jdtls",
            },
            config = function()
                require("cfg.lsp")(lsp_servers)
            end,
        },

        {
            "numToStr/Comment.nvim",
            config = function()
                local comment = require("Comment")
                comment.setup(require("opt.Comment"))
            end
        },

        {
            "nvim-lualine/lualine.nvim",
            config = function()
                local lualine = require("lualine")
                lualine.setup(require("opt.lualine")(icons_enabled))
            end,
        },

        {
            "windwp/nvim-autopairs",
            -- event = "InsertEnter",
            config = function()
                local autopairs = require("nvim-autopairs")
                autopairs.setup(require("opt.autopairs"))
            end,
        },

        {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                local ibl = require("ibl")
                ibl.setup(require("opt.indent-blankline"))
            end,
        },

        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.4",
            dependencies = {

                { "nvim-lua/plenary.nvim", },

                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make",
                    conf = function()
                        return vim.fn.executable("make") == 1
                    end,
                },

            },
            config = require("cfg.telescope")
        },

        {
            "folke/which-key.nvim",
            config = require("cfg.which-key")
        },

        {
            "nvim-tree/nvim-tree.lua",
            config = require("cfg.tree")
        },

        { "tpope/vim-fugitive" },

        { "airblade/vim-gitgutter" },

    }
end
