M = {}

local noremap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = desc,
    })
end
M.noremap = noremap

local noremap_prompt = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        nowait = true,
        desc = desc,
    })
end
M.noremap_prompt = noremap_prompt 

local bufnoremap = function(mode, lhs, rhs, bufnr, desc)
    vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        nowait = true,
        buffer = bufnr,
        desc = desc,
    })
end
M.bufnoremap = bufnoremap

M.nbufnoremap = function(lhs, rhs, bufnr, desc)
    bufnoremap("n", lhs, rhs, bufnr, desc)
end

M.nnoremap = function(lhs, rhs, desc)
    noremap("n", lhs, rhs, desc)
end

M.nnoremap_prompt = function(lhs, rhs, desc)
    noremap_prompt("n", lhs, rhs, desc)
end

M.xnoremap_prompt = function(lhs, rhs, desc)
    noremap_prompt("x", lhs, rhs, desc)
end

M.inoremap = function(lhs, rhs, desc)
    noremap("i", lhs, rhs, desc)
end

M.xnoremap = function(lhs, rhs, desc)
    noremap("x", lhs, rhs, desc)
end

M.isnoremap = function(lhs, rhs, desc)
    noremap({ "i", "s" }, lhs, rhs, desc)
end

M.nvnoremap = function(lhs, rhs, desc)
    noremap({ "n", "v" }, lhs, rhs, desc)
end

M.nxnoremap = function(lhs, rhs, desc)
    noremap({ "n", "x" }, lhs, rhs, desc)
end

M.tnoremap = function(lhs, rhs, desc)
    noremap("t", lhs, rhs, desc)
end

return M
