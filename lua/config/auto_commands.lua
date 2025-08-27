-- Conceal passwords in password files
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = { '*.pass' },
    callback = function(ev)
        vim.cmd("setlocal noundofile")
        vim.cmd("syntax match ConcealPasswords /_\\\".*\\\"$/ conceal")
        nnoremap(
            "yy",
            function()
                local line = vim.api.nvim_get_current_line()
                local password = string.gsub(line, "^.*_\"(.*)\"$", "%1")
                vim.fn.setreg("+", password)
            end,
            "Copy password"
        )
    end,
})
