-- Additional encryption utilities
local crypt = require("crypt")

vim.api.nvim_create_user_command("PassDecrypt", function()
    local file = crypt.get_buffer_path(0)
    if file == nil then
        return
    end

    local password = crypt.get_password()
    if password == nil then
        return
    end

    if not crypt.decrypt(file, password) then
        return
    end

    vim.api.nvim_buf_set_lines(0, -1, -1, false, { password })
end, {})

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

    if not crypt.encrypt(file, password) then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { password })
        vim.cmd("write")
        return
    end
end, {})

-- Conceal passwords in password files
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = { '*.pass' },
    callback = function(ev)
        vim.cmd("setlocal noundofile")
        vim.cmd("syntax match ConcealPasswords /_\\\".*\\\"$/ conceal")
        nnoremap(
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
