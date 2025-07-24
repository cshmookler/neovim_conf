return function()
    local bigfile = require("bigfile")
    bigfile.setup({
        pattern = function(bufnr, filesize_mib)
            local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
            return filesize > 1024 * 128
        end,
        features = {
            "indent_blankline",
            "illuminate",
            "lsp",
            "treesitter",
            "syntax",
            "matchparen",
            "vimopts",
            "filetype",
        },
    })
end
