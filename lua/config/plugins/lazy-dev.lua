return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
    config = function(plugin, opts)
        local lazydev = require("lazydev")
        lazydev.setup(opts)

        local cmp = require("cmp")
        table.insert(cmp.get_config().sources, {
            name = "lazydev",
            priority = 100, -- high
            keyword_length = 0,
        })
    end,
}
