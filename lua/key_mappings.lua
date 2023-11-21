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
    nnoremap("<Leader>?", ":WhichKey<CR>", "Show custom keymaps")

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

    local hide_last_cmd = function()
        -- Conceal the entered command
        vim.cmd.echomsg("\"\"")

        -- Delete the entered command from history
        vim.fn.histdel(":", -1)
    end

    local vim_cmd_with_output = function(cmd)
        local success, output_info = pcall(vim.api.nvim_exec2, cmd, { output = true })
        if not success then
            return nil
        end
        return vim.split(output_info.output, "\n")[3]
    end

    local vim_cmd = function(cmd)
        return pcall(vim.api.nvim_command, cmd)
    end

    -- Crypt cracker
    vim.api.nvim_create_user_command("Crypt", function(this)
        hide_last_cmd()

        -- Get path to current buffer
        local orig_file = vim.fn.expand("%")
        if orig_file == "" then
            print("Invalid buffer")
            return
        end

        -- Get command arguments
        local args = vim.split(this.args, " ")
        local args_count = vim.tbl_count(args)
        if args_count ~= 3 then
            print("Invalid number of arguments")
            return
        end

        -- Get path to pad
        local pad = args[1]
        if not pad then
            print("Invalid pad path")
            return
        end
        pad = vim.fs.normalize(pad)

        -- Get pad position
        local pos = args[2]
        if not pos then
            print("Invalid pad position")
            return
        end

        -- Get the password
        local pass = args[3]
        if not pass then
            print("Invalid password")
            return
        end

        -- Create a temp file
        local temp_file = vim_cmd_with_output("! mktemp")
        if not temp_file then
            print("Failed to create temp file")
            return
        end

        -- Temporarily disable unnecessary usage of persistent storage
        local orig_opt_undofile = vim.o.undofile
        local orig_opt_swapfile = vim.o.swapfile
        local orig_opt_backup = vim.o.backup
        vim.opt.undofile = false
        vim.opt.swapfile = false
        vim.opt.backup = false

        -- Prevent writing

        local cleanup = function()
            -- Destroy the temp file
            local output = vim_cmd_with_output("! shred -zun 3 " .. temp_file)
            if not output then
                print("Failed to remove temp file: '" .. output .. "'")
                return
            end

            -- Edit the original file
            if not vim_cmd("edit! " .. orig_file) then
                print("Failed to return to the original file")
                return
            end

            -- Restore original options
            vim.opt.undofile = orig_opt_undofile
            vim.opt.swapfile = orig_opt_swapfile
            vim.opt.backup = orig_opt_backup
        end

        -- XOR decryption stage
        local output = vim_cmd_with_output("! xorc " ..
            orig_file .. " " .. temp_file .. " --pad=" .. pad .. " --pos=" .. pos)
        if not output then
            print("XOR decryption failed: '" .. output .. "'")
            cleanup()
            return
        end

        -- Edit the temp file
        if not vim_cmd("edit! " .. temp_file) then
            print("Failed to edit temp file")
            cleanup()
            return;
        end

        -- AES decryption stage
        if not vim_cmd("%delete") then
            print("Failed to clear buffer")
            cleanup()
            return
        end

        if not vim_cmd("read! openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -k " ..
                pass .. " -in " .. temp_file) then
            print("AES decryption failed")
            cleanup()
            return
        end

        vim.keymap.set("n", "<Leader>w", ":echo 'This file is read-only'<CR>")
        vim.keymap.set("n", "<Leader>q", ":qa!<CR>")

        -- Set the temp file to read only to prevent accidental writes
        if not vim_cmd("set readonly") then
            print("Failed to set temp file as read only")
            cleanup()
            return
        end

        vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "RemoveLeadingNewline", function(_)
            vim.cmd("1,1s/\n//")
        end, {})

        vim.cmd("RemoveLeadingNewline")

        local crypt_quit = function(_)
            -- AES encryption stage
            if not vim_cmd("silent write ! openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -k " .. pass .. " -out " .. temp_file) then
                print("AES encryption failed")
                cleanup()
                return
            end

            -- XOR encryption stage
            output = vim_cmd_with_output("! xorc " ..
                temp_file .. " " .. orig_file .. " --pad=" .. pad .. " --pos=" .. pos)
            if not output then
                print("XOR encryption failed: '" .. output .. "'")
                cleanup()
                return
            end

            cleanup()
        end

        vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "CryptQuit", function(_)
            hide_last_cmd()
            crypt_quit()
        end, {})

        vim.api.nvim_create_autocmd({ "ExitPre" }, {
            buffer = vim.api.nvim_get_current_buf(),
            callback = crypt_quit,
        })
    end, { nargs = "*" })
end
