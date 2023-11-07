return function()

    require("util.keymap")

    -- Quick buffer management.
    nnoremap("<Leader>q", ":q<CR>")
    nnoremap("<Leader>Q", ":qa<CR>")
    nnoremap("<Leader>w", ":w<CR>")
    nnoremap("<Leader>W", ":wa<CR>")

    -- Quickly move between panes.
    nnoremap("<C-h>", "<C-w>h")
    nnoremap("<C-j>", "<C-w>j")
    nnoremap("<C-k>", "<C-w>k")
    nnoremap("<C-l>", "<C-w>l")

    -- Quick tab management.
    nnoremap("<C-n>", vim.cmd.tabnext)
    nnoremap("<C-m>", vim.cmd.tabprev)
    nnoremap("<C-b>", vim.cmd.tabnew)

    -- Integrated terminal.
    nnoremap("<Leader>t", ":split<CR>:terminal<CR>A")
    tnoremap("<C-e>", "<C-\\><C-n>")
    tnoremap("<C-h>", "<C-\\><C-n><C-w>h")
    tnoremap("<C-j>", "<C-\\><C-n><C-w>j")
    tnoremap("<C-k>", "<C-\\><C-n><C-w>k")
    tnoremap("<C-l>", "<C-\\><C-n><C-w>l")
    tnoremap("<C-d>", "<C-\\><C-n>:close<CR>")
    tnoremap("<C-r>", "<C-\\><C-n>:terminal<CR>A")

    -- NvimTree key mappings.
    local nvim_tree_api = require("nvim-tree.api")
    nnoremap("<C-p>", nvim_tree_api.tree.toggle)
    nnoremap("<C-x>", function()
        nvim_tree_api.tree.close()
        vim.cmd(":q")
    end)

    -- Recognize common template file extensions.
    vim.cmd.au("BufNewFile,BufRead", "*.py.tmpl", ":set filetype=python")
    vim.cmd.au("BufNewFile,BufRead", "meson.build.tmpl", ":set filetype=meson")
    vim.cmd.au("BufNewFile,BufRead", "*.hpp.in.tmpl", ":set filetype=cpp")
    vim.cmd.au("BufNewFile,BufRead", "*.cpp.tmpl", ":set filetype=cpp")

end
