return {
    "hrsh7th/cmp-cmdline",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
    },
    config = function(plugin, opts)
        local cmp = require("cmp")

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                {
                    name = "buffer",
                },
            },
        })

        cmp.setup.cmdline({ ":" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                {
                    name = "path",
                },
                {
                    name = "cmdline",
                },
            },
            matching = {
                disallow_symbol_nonprefix_matching = false
            },
        })
    end,
}
