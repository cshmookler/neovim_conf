return function()
    local configs = require("nvim-treesitter.configs")
    ---@diagnostic disable-next-line: missing-fields
    configs.setup({
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    })
end
