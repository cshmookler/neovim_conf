local crypt = require("crypt")

vim.api.nvim_create_user_command("PassEncrypt", function()
    local file = crypt.get_buffer_path(0)
    if file == nil then
        return
    end

    local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, true)
    if last_line == nil then
        return
    end

    local password = last_line[1]
    if password:len() == 0 then
        vim.notify(
            "The last line must contain at least one character.  The last line is used as the password for encryption.",
            vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_buf_set_lines(0, -2, -1, false, {})
    vim.cmd("write")

    local out = file .. ".crypt"

    vim.uv.fs_rename(file, out)

    if not crypt.encrypt(out, password) then
        vim.uv.fs_rename(out, file)
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { password })
        vim.cmd("write")
        return
    end

    vim.cmd("edit! " .. out)
end, {})


local has_suffix = function(str, suffix)
    return str:sub(- #suffix) == suffix
end

local remove_suffix = function(str, suffix)
    if not has_suffix(str, suffix) then
        return str
    end

    return str:sub(1, - #suffix - 1)
end

vim.api.nvim_create_user_command("PassDecrypt", function()
    local file = crypt.get_buffer_path(0)
    if file == nil then
        return
    end

    local crypt_suffix = ".crypt"
    if not has_suffix(file, crypt_suffix) then
        vim.notify("Missing suffix '" .. crypt_suffix .. "'", vim.log.levels.ERROR)
        return
    end
    local out = remove_suffix(file, crypt_suffix)

    local password = crypt.get_password()
    if password == nil then
        return
    end

    vim.uv.fs_rename(file, out)

    if not crypt.decrypt(out, password) then
        vim.uv.fs_rename(out, file)
        return
    end

    vim.cmd("edit! " .. out)
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { password })
    vim.cmd("silent write")
end, {})

-- Conceal passwords in password files
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = { '*.pass' },
    callback = function(ev)
        vim.cmd("setlocal noundofile")
        vim.cmd("setlocal concealcursor=nc")
        vim.cmd("setlocal conceallevel=3")
        vim.cmd("syntax match ConcealPasswords /_\\\".*\\\"$/ conceal")
        local utils = require("config.utils")
        utils.nnoremap(
            "yy",
            function()
                local line = vim.api.nvim_get_current_line()
                local password = string.gsub(line, "^.*_\"(.*)\"$", "%1")
                vim.fn.setreg("+", password)
            end,
            "Copy password"
        )
    end,
})

-- Prevent writing to encrypted password files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.crypt" },
    callback = function(ev)
        vim.bo.readonly = true
    end,
})
vim.api.nvim_create_autocmd("BufWriteCmd", {
    pattern = { "*.crypt" },
    callback = function(ev)
        vim.notify("Write blocked for " .. ev.file, vim.log.levels.WARN)
    end,
})

-- Remove buffers that are not viewed into by a window
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        local all_wins = vim.api.nvim_list_wins()

        local all_bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(all_bufs) do
            local delete_buf = true

            for _, win in ipairs(all_wins) do
                local win_buf = vim.api.nvim_win_get_buf(win)
                if win_buf == buf then
                    delete_buf = false
                    break
                end
            end

            if delete_buf then
                local buf_valid = vim.api.nvim_buf_is_valid(buf)
                if buf_valid then
                    local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
                    if buftype ~= "nofile" then
                        vim.api.nvim_buf_delete(buf, { force = buftype == "terminal" })
                    end
                end
            end
        end
    end
})
