return function()
    require("util.keymap")

    -- Move by visual lines instead of actual lines.
    nvnoremap("j", "gj", "Move down by visual line")
    nvnoremap("k", "gk", "Move up by one visual line")

    -- Fast vertical movement
    nvnoremap("H", "3b", "Three words left")
    nvnoremap("J", "3gj", "Three visual lines down")
    nvnoremap("K", "3gk", "Three visual lines up")
    nvnoremap("L", "3w", "Three words right")

    -- More intuitive undo and redo
    nnoremap("u", "u", "Undo")
    nnoremap("U", "<C-r>", "Redo")

    -- Quickly move between and manipulate panes
    nnoremap("<C-h>", "<C-w>h", "Go to the left window")
    nnoremap("<C-j>", "<C-w>j", "Go to the down window")
    nnoremap("<C-k>", "<C-w>k", "Go to the up window")
    nnoremap("<C-l>", "<C-w>l", "Go to the right window")
    nnoremap("<C-x>", "<C-w>x", "Swap with the next window")

    -- Quick buffer management
    nnoremap("<Leader>q", function()
        local bufnr = vim.api.nvim_get_current_buf()
        ---@diagnostic disable-next-line: param-type-mismatch
        local buf_windows = vim.call("win_findbuf", bufnr)
        local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
        local name = vim.api.nvim_buf_get_name(bufnr)
        if modified and #buf_windows == 1 then
            vim.ui.input({
                prompt = "Save unwritten changes to " .. name .. "?\n[Y]es, (N)o, (C)ancel: ",
            }, function(input)
                if input == "c" or input == "C" then
                    return
                end

                if input == "n" or input == "N" then
                    vim.cmd("q!")
                    return
                end

                if name == "" then
                    print("Error: No file name")
                    return
                end

                vim.cmd("wq")
            end)
        else
            vim.cmd("q")
        end
    end, "Quit")
    nnoremap("<Leader>Q", ":qa<CR>", "Quit all")
    nnoremap("<Leader>w", ":w<CR>", "Write")
    nnoremap("<Leader>W", ":wa<CR>", "Write all")

    -- Quick tab management
    nnoremap("<C-f>", ":tabnext<CR>", "Next tab")
    nnoremap("<C-s>", ":tabprevious<CR>", "Previous tab")
    nnoremap("<C-b>", ":tabnew<CR>:NvimTreeOpen<CR>", "Open new tab")

    -- Integrated terminal
    nnoremap("<Leader>t", ":split<CR>:terminal<CR>A", "Open horizontal terminal")
    nnoremap("<Leader>T", ":vsplit<CR>:terminal<CR>A", "Open vertical terminal")
    tnoremap("<C-e>", "<C-\\><C-n>", "Exit terminal mode")
    tnoremap("<C-h>", "<C-\\><C-n><C-w>h", "Go to the left window")
    tnoremap("<C-j>", "<C-\\><C-n><C-w>j", "Go to the down window")
    tnoremap("<C-k>", "<C-\\><C-n><C-w>k", "Go to the up window")
    tnoremap("<C-l>", "<C-\\><C-n><C-w>l", "Go to the right window")
    tnoremap("<C-d>", "<C-\\><C-n>:quit<CR>", "Close terminal")
    tnoremap("<C-r>", "<C-\\><C-n>:terminal<CR>A", "Refresh terminal")
    tnoremap("<C-f>", "<C-\\><C-n>:tabnext<CR>", "Next tab")
    tnoremap("<C-s>", "<C-\\><C-n>:tabprevious<CR>", "Previous tab")
    tnoremap("<C-b>", "<C-\\><C-n>:tabnew<CR>:NvimTreeOpen<CR>", "Open new tab")

    -- NvimTree key mappings
    local nvim_tree_api = require("nvim-tree.api")
    nnoremap("<C-p>", nvim_tree_api.tree.toggle, "Toggle file tree")

    -- WhichKey mappings
    nnoremap("<Leader>?", ":WhichKey<CR>", "Show custom keymaps")

    -- Refactoring
    xnoremap_prompt("<Leader>re", ":Refactor extract ", "Extract")
    xnoremap_prompt("<Leader>rf", ":Refactor extract_to_file ", "Extract to file")
    xnoremap_prompt("<Leader>rv", ":Refactor extract_var ", "Extract variable")
    noremap_prompt({ "n", "x" }, "<Leader>ri", ":Refactor inline_var", "Inline variable")
    nnoremap_prompt("<Leader>rI", ":Refactor inline_func", "Inline function")
    nnoremap_prompt("<Leader>rb", ":Refactor extract_block", "Extract block")
    nnoremap_prompt("<Leader>rbf", ":Refactor extract_block_to_file", "Extract block to file")

    -- Zen mode
    nnoremap("<Leader>f", ":ZenMode<CR>", "Toggle zen mode")

    -- Yanky
    nxnoremap("y", "<Plug>(YankyYank)")
    nxnoremap("p", "<Plug>(YankyPutAfter)")
    nxnoremap("P", "<Plug>(YankyPutBefore)")
    nxnoremap("gp", "<Plug>(YankyGPutAfter)")
    nxnoremap("gP", "<Plug>(YankyGPutBefore)")
    nnoremap("t", "<Plug>(YankyCycleForward)")
    nnoremap("T", "<Plug>(YankyCycleBackward)")
    nnoremap("]p", "<Plug>(YankyPutIndentAfterLinewise)")
    nnoremap("[p", "<Plug>(YankyPutIndentBeforeLinewise)")
    nnoremap("]P", "<Plug>(YankyPutIndentAfterLinewise)")
    nnoremap("[P", "<Plug>(YankyPutIndentBeforeLinewise)")
    nnoremap(">p", "<Plug>(YankyPutIndentAfterShiftRight)")
    nnoremap("<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
    nnoremap(">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
    nnoremap("<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")
    nnoremap("=p", "<Plug>(YankyPutAfterFilter)")
    nnoremap("=P", "<Plug>(YankyPutBeforeFilter)")

    -- Documentation generator (Doge)
    vim.g.doge_enable_mappings = 0;
    nnoremap("<Leader>d", "<Plug>(doge-generate)", "Doc gen")
    noremap({ "n", "i", "x" }, "<Tab>", "<Plug>(doge-comment-jump-forward)", "Doc next field")
    noremap({ "n", "i", "x" }, "<S-Tab>", "<Plug>(doge-comment-jump-backward)", "Doc previous field")
end
