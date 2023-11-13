noremap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = desc,
    })
end

bufnoremap = function(mode, lhs, rhs, bufnr, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        nowait = true,
        buffer = bufnr,
        desc = desc,
    })
end

nbufnoremap = function(lhs, rhs, bufnr, desc)
    bufnoremap("n", lhs, rhs, bufnr, desc)
end

nnoremap = function(lhs, rhs, desc)
    noremap("n", lhs, rhs, desc)
end

isnoremap = function(lhs, rhs, desc)
    noremap({ "i", "s" }, lhs, rhs, desc)
end

nvnoremap = function(lhs, rhs, desc)
    noremap({ "n", "v" }, lhs, rhs, desc)
end


tnoremap = function(lhs, rhs, desc)
    noremap("t", lhs, rhs, desc)
end
