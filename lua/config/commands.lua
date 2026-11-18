-- Remove buffers that are not viewed into by a window
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(_)
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
