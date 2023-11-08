function noremap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = desc,
    })
end

function bufnoremap(mode, lhs, rhs, bufnr, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        nowait = true,
        buffer = bufnr,
        desc = desc,
    })
end

function nbufnoremap(lhs, rhs, bufnr, desc)
    bufnoremap("n", lhs, rhs, bufnr, desc)
end

function nnoremap(lhs, rhs, desc)
    noremap("n", lhs, rhs, desc)
end

function tnoremap(lhs, rhs, desc)
    noremap("t", lhs, rhs, desc)
end
