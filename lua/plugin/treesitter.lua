return function()
    local treesitter_configs = require("nvim-treesitter.configs")
    treesitter_configs.setup({
        ensure_installed = { "c", "cpp", "lua", "python", "vim", "vimdoc", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
    })
end
