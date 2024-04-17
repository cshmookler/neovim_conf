return function()
    -- Recognize common template file extensions
    vim.cmd.au("BufNewFile,BufRead", "*.py.tmpl", ":set filetype=python")
    vim.cmd.au("BufNewFile,BufRead", "meson.build.tmpl", ":set filetype=meson")
    vim.cmd.au("BufNewFile,BufRead", "*.hpp.in.tmpl", ":set filetype=cpp")
    vim.cmd.au("BufNewFile,BufRead", "*.cpp.tmpl", ":set filetype=cpp")

    -- Delete the last item in command history
    local hide_last_cmd = function()
        -- Conceal the entered command
        vim.cmd.echomsg("\"\"")

        -- Delete the entered command from history
        vim.fn.histdel(":", -1)
    end

    -- Execute a command in a shell and store the output
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

    vim.api.nvim_create_user_command("SudoWrite", function(_)
        local current_buf = vim.api.nvim_get_current_buf();
        local temp_file = vim_cmd_with_output("! mktemp")
        if not temp_file then
            print("Failed to create temp file")
            return
        end
        if not vim_cmd_with_output("write! " .. temp_file) then
            print("Failed to write to temp file")
            return
        end
        local dest_file = vim.api.nvim_buf_get_name(current_buf);
        local password = vim.fn.inputsecret({ prompt = "Password: " })
        if password == "" then
            return
        end
        os.execute("bash -c 'echo " .. password .. " | sudo -Sk mv " .. temp_file .. " " .. dest_file .. "'")
        if not vim_cmd_with_output("edit! " .. dest_file) then
            print("Failed to reopen the destination file")
            return
        end
    end, {})

    -- Spell checker
    vim.api.nvim_create_user_command("SpellCheck", "term set modifiable ; aspell --lang=en_US check %", {})

    -- Automatically close the finished process (spell checker) when it exits
    vim.api.nvim_create_autocmd({ "TermClose" }, { pattern = "*", command = "execute 'bdelete! ' . expand('<abuf>')" })

    -- Get input for the generating and cracking encrypted files
    local get_crypt_info = function()
        local pad = vim.fn.inputsecret({ prompt = "Pad: " })
        if pad == "" then
            return
        end
        pad = vim.fs.normalize(pad)

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

    -- Create an encrypted file
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

    -- Crack an encrypted file
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

            -- Reset Zen mode mapping
            nnoremap("<Leader>f", ":ZenMode<CR>", "Toggle zen mode")
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

        -- Modify zen mode to include "blinder mode"
        nnoremap("<Leader>f",
            ":ZenMode<CR>:lua vim.api.nvim_open_win(vim.api.nvim_create_buf({}, {}), 1, { relative='editor', width=50, height=10, col=10, row=10, focusable=false, style='minimal'})<CR>",
            "Toggle zen mode")

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
