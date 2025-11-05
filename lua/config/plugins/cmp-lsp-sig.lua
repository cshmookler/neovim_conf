return {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function(plugin, opts)
        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, {
            name = "nvim_lsp_signature_help",
            group_index = 1,
            priority = 1000, -- very high
            keyword_length = 0,
        })
        cmp.setup(config)
    end,
}
