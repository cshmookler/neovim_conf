return {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function(plugin, opts)
        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, {
            name = "nvim_lsp",
            group_index = 1,
            priority = 100, -- high
            keyword_length = 0,
            entry_filter = function(entry, _)
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
            end,
        })
        cmp.setup(config)
    end,
}
