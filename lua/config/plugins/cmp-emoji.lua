return {
    "hrsh7th/cmp-emoji",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function(plugin, opts)
        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, {
            name = "emoji",
            group_index = 2,
            priority = 10, -- low
            keyword_length = 1,
            max_item_count = 30,
        })
        cmp.setup(config)
    end,
}
