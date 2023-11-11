return function()
    local better_escape = require("better_escape")
    better_escape.setup({
        mapping = { "jk", "kj" },
        timeout = vim.o.timeoutlen,
        clear_empty_lines = true,
        keys = "<Esc>",
    })
end
