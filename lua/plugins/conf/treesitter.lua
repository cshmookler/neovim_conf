return function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        auto_install = true,
        ensure_installed = "maintained",
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    })
end
