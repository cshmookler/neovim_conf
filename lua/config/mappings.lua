local utils = require("config.utils")

-- Move by visual lines instead of actual lines.
utils.nvnoremap("j", "gj", "Move down by visual line")
utils.nvnoremap("k", "gk", "Move up by one visual line")

-- Fast vertical movement
utils.nvnoremap("H", "3b", "Three words left")
-- nvnoremap("J", "3j", "Three lines down")
-- nvnoremap("K", "3k", "Three lines up")
utils.nvnoremap("J", "3gj", "Three visual lines down")
utils.nvnoremap("K", "3gk", "Three visual lines up")
utils.nvnoremap("L", "3w", "Three words right")

-- More intuitive undo and redo
utils.nnoremap("u", "u", "Undo")
utils.nnoremap("U", "<C-r>", "Redo")

-- Quickly move between and manipulate panes
utils.nnoremap("<C-h>", "<C-w>h", "Go to the left window")
utils.nnoremap("<C-j>", "<C-w>j", "Go to the down window")
utils.nnoremap("<C-k>", "<C-w>k", "Go to the up window")
utils.nnoremap("<C-l>", "<C-w>l", "Go to the right window")
-- utils.nnoremap("H", "3<C-w><", "Decrease window width")
-- utils.nnoremap("J", "3<C-w>-", "Decrease window height")
-- utils.nnoremap("K", "3<C-w>+", "Increase window height")
-- utils.nnoremap("L", "3<C-w>>", "Increase window width")
utils.nnoremap("<C-x>", "<C-w>x", "Swap with the next window")

-- Split panes
utils.nnoremap("<Leader>s", ":split<CR>", "Split this window horizontally")
utils.nnoremap("<Leader>S", ":vsplit<CR>", "Split this window horizontally")

-- Incremental indenting
utils.xnoremap("<", "<gv", "Indent to the left")
utils.xnoremap(">", ">gv", "Indent to the right")

-- Quick buffer management
utils.nnoremap("<Leader>q", function()
    local current_win = vim.api.nvim_get_current_win()

    local all_wins = vim.api.nvim_list_wins()
    local other_wins = {}
    for _, win in ipairs(all_wins) do
        if current_win ~= win then
            table.insert(other_wins, win)
        end
    end

    local current_buf = vim.api.nvim_win_get_buf(current_win)

    local close_win = #vim.api.nvim_list_wins() > 1
    local delete_buf = true

    for _, other_win in ipairs(other_wins) do
        local other_buf = vim.api.nvim_win_get_buf(other_win)
        if current_buf == other_buf then
            delete_buf = false
            break
        end
    end

    if close_win then
        vim.api.nvim_win_close(current_win, true)
    end
    if delete_buf then
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = current_buf })
        vim.api.nvim_buf_delete(current_buf, { force = buftype == "terminal" })
    end
    if not close_win then
        vim.cmd("quit")
    end
end, "Quit")
utils.nnoremap("<Leader>Q", function()
    local current_tabpage = vim.api.nvim_get_current_tabpage()
    local current_wins = vim.api.nvim_tabpage_list_wins(current_tabpage)

    local all_wins = vim.api.nvim_list_wins()
    local other_wins = {}
    for _, window in ipairs(all_wins) do
        local not_current_win = true

        for _, current_win in ipairs(current_wins) do
            if current_win == window then
                not_current_win = false
                break
            end
        end

        if not_current_win then
            table.insert(other_wins, window)
        end
    end

    for _, current_win in ipairs(current_wins) do
        local current_buf = vim.api.nvim_win_get_buf(current_win)

        local close_win = #vim.api.nvim_list_wins() > 1
        local delete_buf = true

        for _, other_win in ipairs(other_wins) do
            local other_buf = vim.api.nvim_win_get_buf(other_win)
            if current_buf == other_buf then
                delete_buf = false
                break
            end
        end

        if close_win then
            vim.api.nvim_win_close(current_win, true)
        end
        if delete_buf then
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = current_buf })
            vim.api.nvim_buf_delete(current_buf, { force = buftype == "terminal" })
        end
        if not close_win then
            vim.cmd("quit")
        end
    end
end, "Quit all in tab")
utils.nnoremap("<C-Q>", ":qa<CR>", "Quit all")
utils.nnoremap("<Leader>w", ":w<CR>", "Write")
utils.nnoremap("<Leader>W", ":wa<CR>", "Write all")

-- Quick tab management
utils.nnoremap("<C-f>", ":tabnext<CR>", "Next tab")
utils.nnoremap("<C-s>", ":tabprevious<CR>", "Previous tab")
utils.nnoremap("<C-b>", ":tabnew<CR>:NvimTreeOpen<CR>", "Open new tab")

-- Integrated terminal
local disable_numbers_and_signcolumn = function()
    vim.cmd.setlocal("nonumber norelativenumber signcolumn=no")
end
local enter_terminal_mode = function()
    vim.api.nvim_input("i")
end
local exit_terminal_mode = function()
    vim.api.nvim_input("<C-\\><C-n>")
end
local create_terminal = function(split_command, back_to_buffer_command)
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    local name = vim.api.nvim_buf_get_name(bufnr)
    vim.cmd(split_command)
    vim.cmd.terminal()
    if name == "" and not modified then
        vim.cmd(back_to_buffer_command)
        vim.cmd.quit()
    end
    disable_numbers_and_signcolumn()
    enter_terminal_mode()
end
local create_horizontal_terminal = function()
    create_terminal("split", "wincmd k")
end
local create_vertical_terminal = function()
    create_terminal("vsplit", "wincmd h")
end
local create_inplace_terminal = function()
    vim.cmd("terminal")
    disable_numbers_and_signcolumn()
end
local refresh_terminal = function()
    exit_terminal_mode()
    create_inplace_terminal()
    enter_terminal_mode()
end
local left_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>h")
end
local down_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>j")
end
local up_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>k")
end
local right_from_terminal = function()
    exit_terminal_mode()
    vim.api.nvim_input("<C-w>l")
end
local next_tab_from_terminal = function()
    exit_terminal_mode()
    vim.cmd.tabnext()
end
local previous_tab_from_terminal = function()
    exit_terminal_mode()
    vim.cmd.tabprevious()
end
local open_new_tab_from_terminal = function()
    exit_terminal_mode()
    vim.cmd.tabnew()
    vim.cmd.NvimTreeOpen()
end
utils.nnoremap("<Leader>t", create_horizontal_terminal, "Open horizontal terminal")
utils.nnoremap("<Leader>T", create_vertical_terminal, "Open vertical terminal")
utils.tnoremap("<C-e>", exit_terminal_mode, "Exit terminal mode")
utils.tnoremap("<C-h>", left_from_terminal, "Go to the left window")
utils.tnoremap("<C-j>", down_from_terminal, "Go to the down window")
utils.tnoremap("<C-k>", up_from_terminal, "Go to the up window")
utils.tnoremap("<C-l>", right_from_terminal, "Go to the right window")
utils.tnoremap("<C-d>", "<C-D>", "Close terminal")
utils.tnoremap("<C-r>", refresh_terminal, "Refresh terminal")
utils.tnoremap("<C-f>", next_tab_from_terminal, "Next tab")
utils.tnoremap("<C-s>", previous_tab_from_terminal, "Previous tab")
utils.tnoremap("<C-b>", open_new_tab_from_terminal, "Open new tab")

-- NvimTree key mappings
local nvim_tree_api = require("nvim-tree.api")
utils.nnoremap("<C-p>", nvim_tree_api.tree.toggle, "Toggle file tree")

-- WhichKey mappings
utils.nnoremap("<Leader>?", ":WhichKey<CR>", "Show custom keymaps")

-- Zen mode
utils.nnoremap("<Leader>f", ":ZenMode<CR>", "Toggle zen mode")

-- Yanky
utils.nxnoremap("y", "<Plug>(YankyYank)")
utils.nnoremap("p", "<Plug>(YankyPutAfter)")
utils.nnoremap("P", "<Plug>(YankyPutBefore)")
utils.xnoremap("p", "\"_dP")
utils.xnoremap("P", "\"_dP")
utils.nnoremap("t", "<Plug>(YankyCycleForward)")
utils.nnoremap("T", "<Plug>(YankyCycleBackward)")

-- -- Documentation generator (Doge)
-- vim.g.doge_enable_mappings = 0;
-- nnoremap("<Leader>d", "<Plug>(doge-generate)", "Doc gen")
-- noremap({ "n", "i", "x" }, "<Tab>", "<Plug>(doge-comment-jump-forward)", "Doc next field")
-- noremap({ "n", "i", "x" }, "<S-Tab>", "<Plug>(doge-comment-jump-backward)", "Doc previous field")

-- Remove all UI elements except for the text itself.
utils.nnoremap("<Leader>F",
    ":set noruler noshowmode noshowcmd laststatus=0 signcolumn=no nonumber norelativenumber nocursorline showtabline=0<CR>",
    "Hide all UI elements")

-- Switch between light and dark mode.
utils.nnoremap("<Leader>L", ":set background=light<CR>", "Enable light mode")
utils.nnoremap("<Leader>D", ":set background=dark<CR>", "Enable dark mode")
