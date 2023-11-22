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
        -- print("cmd: " ..
        --     cmd .. "\n" .. "status: " .. vim.api.nvim_get_vvar("shell_error") .. "\n" .. "success: " .. tostring(success))
        if vim.api.nvim_get_vvar("shell_error") ~= 0 then
            return nil
        end
        if not success then
            print("Lua function call error")
            return nil
        end
        if not output_info.output then
            return ""
        end
        local output = vim.split(output_info.output, "\n")[3]
        if not output then
            return ""
        end
        return output
    end

    local get_crypt_info = function()
        local pad = vim.fn.inputsecret({ prompt = "Pad: " })
        if pad == "" then
            return
        end

        local pos = vim.fn.inputsecret({ prompt = "Pos: " })
        if pos == "" then
            return
        end

        local pass = vim.fn.inputsecret({ prompt = "Pass: " })
        if pass == "" then
            return
        end

        return pad, pos, pass
    end

    vim.api.nvim_create_user_command("CryptGen", function(_)
        hide_last_cmd()

        -- local buf = vim.api.nvim_get_current_buf()

        local pad, pos, pass = get_crypt_info()
        if not pad or not pos or not pass then
            return
        end

        -- Get path to current buffer
        local orig_file = vim.fn.expand("%")
        if orig_file == "" then
            print("Invalid buffer")
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

        local cleanup = function()
            -- Destroy the temp file
            local output = vim_cmd_with_output("! shred -zun 3 " .. temp_file)
            if not output then
                print("Failed to remove temp file")
                return
            end

            -- Restore original options
            vim.opt.undofile = orig_opt_undofile
            vim.opt.swapfile = orig_opt_swapfile
            vim.opt.backup = orig_opt_backup
        end

        -- AES encryption stage
        local output = vim_cmd_with_output(
            "silent write ! openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -k " ..
            pass .. " -out " .. temp_file)
        if not output then
            print("AES encryption failed")
            cleanup()
            return
        end

        -- XOR encryption stage
        output = vim_cmd_with_output("! xorc " ..
            temp_file .. " " .. orig_file .. " --pad=" .. pad .. " --pos=" .. pos)
        if not output then
            print("XOR encryption failed")
            cleanup()
            return
        end

        cleanup()
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("CryptCrack", function(_)
        hide_last_cmd()

        local buf = vim.api.nvim_get_current_buf()

        local pad, pos, pass = get_crypt_info()
        if not pad or not pos or not pass then
            return
        end

        -- Get path to current buffer
        local orig_file = vim.fn.expand("%")
        if orig_file == "" then
            print("Invalid buffer")
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

        local cleanup_no_wipeout = function()
            -- Destroy the temp file
            local output = vim_cmd_with_output("! shred -zun 3 " .. temp_file)
            if not output then
                print("Failed to remove temp file")
            end

            -- Restore original options
            vim.opt.undofile = orig_opt_undofile
            vim.opt.swapfile = orig_opt_swapfile
            vim.opt.backup = orig_opt_backup
        end

        local cleanup_switch_to_orig_file = function()
            cleanup_no_wipeout()

            -- Edit the original file
            if not vim_cmd_with_output("edit! " .. orig_file) then
                print("Failed to edit original file")
            end
        end

        local cleanup = function()
            cleanup_no_wipeout()

            -- Wipeout the buffer
            if not vim_cmd_with_output(":bwipeout " .. buf) then
                print("Failed to wipeout buffer")
            end
        end

        -- XOR decryption stage
        local output = vim_cmd_with_output("! xorc " ..
            orig_file .. " " .. temp_file .. " --pad=" .. pad .. " --pos=" .. pos)
        if not output then
            print("XOR decryption failed")
            cleanup_no_wipeout()
            return
        end

        -- Edit the temp file
        if not vim_cmd_with_output("edit! " .. temp_file) then
            print("Failed to edit temp file")
            cleanup_switch_to_orig_file()
            return;
        end

        buf = vim.api.nvim_get_current_buf()

        -- Prevent writing unencrypted data to disk
        vim.bo[buf].buftype = "nofile"

        -- AES decryption stage
        if not vim_cmd_with_output("%delete") then
            print("Failed to clear buffer")
            cleanup_switch_to_orig_file()
            return
        end
        output = vim_cmd_with_output("read! openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -k " ..
            pass .. " -in " .. temp_file)
        if not output then
            print("AES decryption failed")
            cleanup_switch_to_orig_file()
            return
        end

        -- Remove the leading newline (auto-generated by :read)
        if not vim_cmd_with_output("0d_") then
            print("Failed to remove the leading newline")
        end

        -- Destroy the temp file
        output = vim_cmd_with_output("! shred -zun 3 " .. temp_file)
        if not output then
            print("Failed to remove temp file")
            cleanup()
            return
        end

        local exited = false
        local crypt_quit = function(_)
            if exited then
                return
            end

            -- Create a new temp file
            temp_file = vim_cmd_with_output("! mktemp")
            if not temp_file then
                print("Failed to create new temp file")
                return
            end

            -- AES encryption stage
            output = vim_cmd_with_output(
                "silent write ! openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -k " ..
                pass .. " -out " .. temp_file)
            if not output then
                print("AES encryption failed")
                cleanup()
                return
            end

            -- XOR encryption stage
            output = vim_cmd_with_output("! xorc " ..
                temp_file .. " " .. orig_file .. " --pad=" .. pad .. " --pos=" .. pos)
            if not output then
                print("XOR encryption failed")
                cleanup()
                return
            end

            cleanup()

            exited = true
        end

        vim.api.nvim_buf_create_user_command(buf, "CryptQuit", function(_)
            hide_last_cmd()
            crypt_quit()
        end, {})

        vim.api.nvim_create_autocmd({ "BufHidden", "BufLeave", "ExitPre" }, {
            buffer = buf,
            callback = crypt_quit,
        })
    end, { nargs = "*" })
end
