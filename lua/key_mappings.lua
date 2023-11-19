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
    nnoremap("<Leader>t", ":split<CR>:terminal<CR>A", "Open horizontal terminal")
    nnoremap("<Leader>T", ":vsplit<CR>:terminal<CR>A", "Open vertical terminal")
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

    -- Recognize common template file extensions
    vim.cmd.au("BufNewFile,BufRead", "*.py.tmpl", ":set filetype=python")
    vim.cmd.au("BufNewFile,BufRead", "meson.build.tmpl", ":set filetype=meson")
    vim.cmd.au("BufNewFile,BufRead", "*.hpp.in.tmpl", ":set filetype=cpp")
    vim.cmd.au("BufNewFile,BufRead", "*.cpp.tmpl", ":set filetype=cpp")

    -- Crypt cracker
    vim.api.nvim_create_user_command("Crypt", function(this)
        -- Conceal the entered command
        vim.cmd.echomsg("\"\"")

        -- Delete the entered command from history
        vim.fn.histdel(":", -1)

        -- Function for saving output from a shell command to a lua variable
        local vim_cmd = function(cmd)
            local nvim_exec2 = vim.api.nvim_exec2(cmd, { output = true })
            return vim.split(nvim_exec2.output, "\n")[3]
        end

        -- Get command arguments
        local args = vim.split(this.args, " ")
        local args_count = vim.tbl_count(args)
        if args_count ~= 2 then
            print("Invalid number of arguments")
            return
        end

        -- Get path to pad
        local pad = args[1]
        if not pad then
            print("Invalid first argument")
            return
        end
        pad = vim.fs.normalize(pad)

        -- Get pad position
        local pos = args[2]
        if not pos then
            print("Invalid second argument")
            return
        end

        -- Get path to current buffer
        local this_file = vim.fn.expand("%")
        if this_file == "" then
            print("Invalid buffer")
            return
        end

        -- Get path to a temp file
        local temp_file = vim_cmd("! mktemp")
        if temp_file == "" then
            print("Failed to create temp file")
            return
        end

        -- Encrypt (or decrypt) the file of the current buffer. Store the resulting data in the temp file.
        local output = vim_cmd("! xorc " .. this_file .. " " .. temp_file .. " --pad=" .. pad .. " --pos=" .. pos)
        if output ~= "" then
            print("First crypt failed: '" .. output .. "'")
            return
        end

        -- Disable unnecessary usage of persistent storage
        vim_cmd("set noundofile noswapfile nobackup")

        -- Edit the temp file
        vim_cmd("edit " .. temp_file);

        vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "CryptQuit", function(this)
            -- Encrypt (or decrypt) the temp file and store the resulting data in the original file
            output = vim_cmd("! xorc " .. temp_file .. " " .. this_file .. " --pad=" .. pad .. " --pos=" .. pos)
            if output ~= "" then
                print("Second crypt failed: '" .. output .. "'")
                return
            end

            -- Edit the original file
            vim_cmd("edit! " .. this_file)

            -- Destroy the temp file
            output = vim_cmd("! shred -zun 3 " .. temp_file)
            if output ~= "" then
                print("Failed to remove temp file: '" .. output .. "'")
                return
            end
        end, {})

        vim.api.nvim_create_autocmd({ "ExitPre" }, {
            buffer = vim.api.nvim_get_current_buf(),
            command = ":CryptQuit",
        })
    end, { nargs = "*" })
end
