return {
    "uga-rosa/cmp-dictionary",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
        paths = { "/etc/nvim/dict" },
        first_case_insensitive = true,
    },
    config = function(plugin, opts)
        local dictionary = require("cmp_dictionary")
        dictionary.setup(opts)

        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, {
            name = "dictionary",
            group_index = 2,
            priority = 10, -- low
            keyword_length = 2,
            max_item_count = 5,
        })
        cmp.setup(config)
    end,
}
