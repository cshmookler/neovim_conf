return function()
    vim.defer_fn(function()
        local treesitter = require("nvim-treesitter.configs")
        treesitter.setup({
            ensure_installed = { "bash", "c", "cpp", "lua", "meson", "python", "rust", "javascript", "typescript", "vim",
                "vimdoc" },
            auto_install = true,
            highight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Leader><C-Space>",
                    node_incremental = "<Leader><C-Space>",
                    scope_incremental = "<Leader><C-s>",
                    node_decremental = "<Leader><M-Space>",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[M"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<Leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<Leader>A"] = "@parameter.inner",
                    },
                },
            },
        })
    end, 0)
end
