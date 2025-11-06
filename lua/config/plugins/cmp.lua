return {
    "hrsh7th/nvim-cmp",
    opts = {
        snippet = {
            expand = function(args)
                vim.snippet.expand(args.body)
            end,
        }
    },
    config = function(plugin, opts)
        local cmp = require("cmp")

        opts.mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping(function(_)
                if cmp.visible() then
                    if cmp.get_active_entry() == nil then
                        cmp.close()
                    else
                        cmp.confirm()
                    end
                else
                    cmp.complete()
                end
            end),
            ["<C-e>"] = cmp.mapping.abort(),
        })

        cmp.setup(opts)
    end,
}
