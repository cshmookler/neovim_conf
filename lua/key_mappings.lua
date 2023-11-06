return function()

    local noremap = function(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
    end

    local nnoremap = function(lhs, rhs)
        noremap("n", lhs, rhs)
    end

    -- Quickly move between panes.
    nnoremap("<C-h>", "<C-w>h")
    nnoremap("<C-j>", "<C-w>j")
    nnoremap("<C-k>", "<C-w>k")
    nnoremap("<C-l>", "<C-w>l")

    -- NvimTree key mappings.
    local nvim_tree_api = require("nvim-tree.api")
    nnoremap("<C-p>", nvim_tree_api.tree.toggle)
    nnoremap("<C-x>", function()
        nvim_tree_api.tree.close()
        vim.cmd(":q")
    end)

end
