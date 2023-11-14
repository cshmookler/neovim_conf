return function()
    require("util.keymap")

    -- Fast vertical movement
    nvnoremap("H", "3b", "Three words left")
    nvnoremap("J", "3j", "Three lines down")
    nvnoremap("K", "3k", "Three lines up")
    nvnoremap("L", "3w", "Three words right")

    -- More intuitive undo and redo
    nnoremap("u", "u", "Undo")
    nnoremap("U", "<C-r>", "Redo")

    -- Quickly move between panes
    nnoremap("<C-h>", "<C-w>h", "Go to the left window")
    nnoremap("<C-j>", "<C-w>j", "Go to the down window")
    nnoremap("<C-k>", "<C-w>k", "Go to the up window")
    nnoremap("<C-l>", "<C-w>l", "Go to the right window")

    -- Quick buffer management
    nnoremap("<Leader>q", ":q<CR>", "Quit")
    nnoremap("<Leader>Q", ":qa<CR>", "Quit all")
    nnoremap("<Leader>w", ":w<CR>", "Write")
    nnoremap("<Leader>W", ":wa<CR>", "Write all")

    -- Quick tab management
    nnoremap("<C-m>", vim.cmd.tabnext, "Next tab")
    nnoremap("<C-n>", vim.cmd.tabprev, "Previous tab")
    nnoremap("<C-b>", function()
        vim.cmd.tabnew()
        vim.cmd("NvimTreeOpen")
        -- require("nvim-tree.api").tree.focus()
    end, "Open new tab")

    -- Integrated terminal
    nnoremap("<Leader>t", ":split<CR>:terminal<CR>A", "Open terminal")
    tnoremap("<C-e>", "<C-\\><C-n>", "Exit terminal mode")
    tnoremap("<C-h>", "<C-\\><C-n><C-w>h", "Go to the left window")
    tnoremap("<C-j>", "<C-\\><C-n><C-w>j", "Go to the down window")
    tnoremap("<C-k>", "<C-\\><C-n><C-w>k", "Go to the up window")
    tnoremap("<C-l>", "<C-\\><C-n><C-w>l", "Go to the right window")
    tnoremap("<C-d>", "<C-\\><C-n>:close<CR>", "Close terminal")
    tnoremap("<C-r>", "<C-\\><C-n>:terminal<CR>A", "Refresh terminal")

    -- NvimTree key mappings
    local nvim_tree_api = require("nvim-tree.api")
    nnoremap("<C-p>", nvim_tree_api.tree.toggle, "Toggle file tree")

    -- WhichKey mappings
    nnoremap("<Leader>?", ":WhichKey<CR>", "Show custom keymaps");

    -- Refactoring
    xnoremap_prompt("<Leader>re", ":Refactor extract ", "Extract")
    xnoremap_prompt("<Leader>rf", ":Refactor extract_to_file ", "Extract to file")
    xnoremap_prompt("<Leader>rv", ":Refactor extract_var ", "Extract variable")
    noremap_prompt({ "n", "x" }, "<leader>ri", ":Refactor inline_var", "Inline variable")
    nnoremap_prompt("<Leader>rI", ":Refactor inline_func", "Inline function")
    nnoremap_prompt("<Leader>rb", ":Refactor extract_block", "Extract block")
    nnoremap_prompt("<Leader>rbf", ":Refactor extract_block_to_file", "Extract block to file")

    -- Zen mode
    nnoremap("<Leader>f", ":ZenMode<CR>", "Toggle zen mode")

    -- Recognize common template file extensions
    vim.cmd.au("BufNewFile,BufRead", "*.py.tmpl", ":set filetype=python")
    vim.cmd.au("BufNewFile,BufRead", "meson.build.tmpl", ":set filetype=meson")
    vim.cmd.au("BufNewFile,BufRead", "*.hpp.in.tmpl", ":set filetype=cpp")
    vim.cmd.au("BufNewFile,BufRead", "*.cpp.tmpl", ":set filetype=cpp")
end
