noremap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

nnoremap = function(lhs, rhs, desc)
    noremap("n", lhs, rhs, desc)
end

tnoremap = function(lhs, rhs, desc)
    noremap("t", lhs, rhs, desc)
end
